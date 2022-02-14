class AddIndexOnCachedHierarchy < ActiveRecord::Migration[5.2]
  def up
    execute <<-SQL
      CREATE INDEX index_geometries_on_cached_hierarchy
      ON geometries
      USING gist(to_tsvector('english',geometries.cached_hierarchy));
    SQL
  end

  def down
    execute <<-SQL
      DROP INDEX IF EXISTS index_geometries_on_cached_hierarchy;
    SQL
  end
end
