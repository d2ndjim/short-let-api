class User < ApplicationRecord
  has_secure_password

  has_many :hall, foreign_key: :created_by_id
  has_many :reservations
  has_many :notified, class_name: 'Notification', foreign_key: :recipient_id
  has_many :notifier, class_name: 'Notification', foreign_key: :admin_id
end
