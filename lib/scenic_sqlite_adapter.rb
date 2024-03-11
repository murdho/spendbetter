# ScenicSqlite implementation adapted from:
# * https://github.com/scenic-views/scenic
# * https://github.com/pdebelak/scenic_sqlite_adapter
module ScenicSqlite
  class View < Scenic::View
    def to_schema
      <<~DEFINITION.indent(2)
        create_view #{Scenic::UnaffixedName.for(name).inspect}, sql_definition: <<-\SQL
        #{escaped_and_formatted_definition}
        SQL
      DEFINITION
    end

    def escaped_and_formatted_definition
      escaped_definition.prepend("    ").strip_heredoc.indent(2)
    end
  end

  class Adapter
    attr_reader :connectable

    delegate :connection, to: :connectable
    delegate :execute, :quote_table_name, to: :connection

    def initialize(connectable = ActiveRecord::Base)
      @connectable = connectable
    end

    CREATE_VIEW_AS_PATTERN = /^CREATE VIEW ".*"\s+AS\s+/i

    def views
      execute("SELECT name, sql FROM sqlite_master WHERE type = 'view'").map do |result|
        View.new(
          name: result["name"],
          definition: result["sql"].strip.sub(CREATE_VIEW_AS_PATTERN, ""),
          materialized: false
        )
      end
    end

    def create_view(name, sql_definition)
      execute "CREATE VIEW #{quote_table_name(name)} AS #{sql_definition}"
    end

    def drop_view(name)
      execute "DROP VIEW #{quote_table_name(name)}"
    end
  end
end
