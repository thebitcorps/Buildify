class AddTrigramSearch < ActiveRecord::Migration
  def change
    execute "create extension pg_trgm;"
    execute "CREATE INDEX name_similarity_idx ON materials USING gist (name gist_trgm_ops);"
    execute "CREATE INDEX description_similarity_idx ON materials USING gist (description gist_trgm_ops);"
  end
end
