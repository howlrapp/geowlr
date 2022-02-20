class Geometry < ApplicationRecord
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

  def self.best_matches_by_location(latitude, longitude)
    locality_within = self.select(:cached_name, :cached_hierarchy, :reference, :lonlat).find_by_latitude_and_longitude(latitude, longitude)
    return locality_within if locality_within.present?

    locality_closest = self.select(:cached_name, :cached_hierarchy, :reference, :lonlat).closest_to_boundary(latitude, longitude)
    return locality_closest if locality_closest.present?

    self.select(:cached_name, :cached_hierarchy, :reference, :lonlat).closest_to(latitude, longitude)
  end
end
