# frozen_string_literal: true

class ConvertNoticesTextToUtf8mb4 < ActiveRecord::Migration[6.1]
  def up
    execute 'ALTER TABLE notices MODIFY COLUMN `text` VARCHAR(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci'
  end

  def down
    execute 'ALTER TABLE notices MODIFY COLUMN `text` VARCHAR(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci'
  end
end
