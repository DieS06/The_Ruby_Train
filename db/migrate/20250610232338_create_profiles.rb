class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.text :bio
      t.string :linkedin_url
      t.string :github_url
      t.string :website_url
      t.string :location
      t.string :company_name
      t.string :job_title
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
