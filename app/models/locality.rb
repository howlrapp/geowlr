class Locality < Geometry
  def name
    extract_most_seen [
      "wof:name",
      "gn:name",
      "ne:NAME",
      "ne:MEGANAME",
      "ne:NAMEASCII",
      "ne:GNASCII",
      "ne:LS_NAME",
      "qs:loc",
      "qs:loc_alt",
      -> { properties['name:eng_x_preferred'].try(:[], 0) }
    ]
  end
end
