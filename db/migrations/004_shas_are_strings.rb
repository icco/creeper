Sequel.migration do
  change do
    alter_table :commits do
      add_column :sha, String
    end
  end
end
