class Geometry < ApplicationRecord
  GEOMETRY_CONTAINERS = {
    region: "Region",
    macroregion: "MacroRegion",
    county: "County",
    country: "Country",
    empire: "Empire"
  }

  def as_json(options = {})
    {
      reference: reference,
      name: cached_name,
      hierarchy: cached_hierarchy,
      latitude: lonlat.latitude,
      longitude: lonlat.longitude,
    }
  end

  scope :find_by_latitude_and_longitude, -> (latitude, longitude) {
    where("geometries.geom IS NOT NULL AND ST_Within(ST_SetSRID(ST_MakePoint(?, ?), 4326), geometries.geom)", longitude.to_f, latitude.to_f)
  }

  scope :closest_to_boundary, -> (latitude, longitude) {
    where("geometries.geom IS NOT NULL AND ST_DWithin(ST_SetSRID(ST_MakePoint(?, ?), 4326), geometries.geom, 1)", longitude.to_f, latitude.to_f)
      .order("geometries.geom <-> ST_SetSRID(ST_MakePoint(#{Arel.sql(longitude.to_f.to_s)}, #{Arel.sql(latitude.to_f.to_s)}), 4326)")
  }

  scope :closest_to, -> (latitude, longitude) {
    order("geometries.lonlat <-> ST_SetSRID(ST_MakePoint(#{Arel.sql(longitude.to_f.to_s)}, #{Arel.sql(latitude.to_f.to_s)}), 4326)")
  }

  GEOMETRY_CONTAINERS.each do |geometry, klass|
    define_method geometry do
      klass.constantize.select(:cached_name).find_by(reference: properties["wof:hierarchy"]&.first.try(:[], "#{geometry}_id"))
    end
  end

  def name
    extract_most_seen [
      "wof:name"
    ]
  end

  def self.best_matches_by_location(latitude, longitude)
    locality_within = self.select(:cached_name, :cached_hierarchy, :reference, :lonlat).find_by_latitude_and_longitude(latitude, longitude)
    return locality_within if locality_within.present?

    locality_closest = self.select(:cached_name, :cached_hierarchy, :reference, :lonlat).closest_to_boundary(latitude, longitude)
    return locality_closest if locality_closest.present?

    self.select(:cached_name, :cached_hierarchy, :reference, :lonlat).closest_to(latitude, longitude)
  end

  protected

  def extract_most_seen(property_keys)
    property_keys.map do |property_key|
      extract_value(property_key)
    end.compact.each_with_object(Hash.new(0)) do |value, frequency|
      frequency[value] += 1
    end.to_a.max_by(&:last).try(:[], 0)
  end

  def extract_value(property_key)
    value =
      if property_key.kind_of?(Proc)
        property_key.call
      else
        properties[property_key]
      end

    if value.present? && (value.kind_of?(Numeric) || value.to_s.length > 1)
      value
    else
      nil
    end
  end
end
