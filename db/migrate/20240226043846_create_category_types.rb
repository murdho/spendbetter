class CreateCategoryTypes < ActiveRecord::Migration[7.2]
  def up
    create_table :category_types do |t|
      t.string :name, null: false, index: { unique: true }
      t.integer :sort_order

      t.timestamps
    end

    change_table :categories do |t|
      t.references :category_type, foreign_key: true, index: true
    end

    %w[required beneficial optional income investment other].each.with_index do |type, i|
      category_type = CategoryType.create!(name: type.capitalize, sort_order: i + 1)
      Category.where(type: type).update_all(category_type_id: category_type.id)
    end

    change_column_null :categories, :category_type_id, false

    remove_check_constraint :categories, "type IN ('required', 'beneficial', 'optional', 'income', 'investment', 'other')"
    remove_column :categories, :type, :string
  end

  def down
    add_column :categories, :type, :string
    add_check_constraint :categories, "type IN ('required', 'beneficial', 'optional', 'income', 'investment', 'other')"

    %w[required beneficial optional income investment other].each do |type|
      category_type = CategoryType.find_by!(name: type.capitalize)
      Category.where(category_type_id: category_type.id).update_all(type: type)
    end

    change_column_null :categories, :type, false

    remove_reference :categories, :category_type, foreign_key: true, index: true
    drop_table :category_types
  end
end
