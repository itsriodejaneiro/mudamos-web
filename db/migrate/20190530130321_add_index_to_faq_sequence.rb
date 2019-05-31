class AddIndexToFaqSequence < ActiveRecord::Migration
  def change
    add_index(:faqs, :sequence)
  end
end
