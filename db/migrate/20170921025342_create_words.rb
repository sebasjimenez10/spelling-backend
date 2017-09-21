class CreateWords < ActiveRecord::Migration[5.1]
  def change
    create_table :words, id: :uuid, default: 'uuid_generate_v4()' do |t|
      t.string :content

      t.timestamps
    end
  end
end
