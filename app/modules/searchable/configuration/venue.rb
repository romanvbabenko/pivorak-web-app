# frozen_string_literal: true

module Searchable
  module Configuration
    module Venue
      include Configurable
      include SearchOptions

      FIELDS = %i[name address description].freeze

      define_searchable do
        multisearchable          against: FIELDS
        pg_search_scope :search, against: FIELDS, using: TSEARCHABLE_WITH_PREFIX
      end
    end
  end
end
