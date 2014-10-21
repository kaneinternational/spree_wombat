require 'active_model/serializer'

module Spree
  module Wombat
    module Jirafe

      class ProductWithoutVariantsSerializer < ActiveModel::Serializer

        attributes :id, :name, :sku, :description, :price, :cost_price,
                   :available_on, :permalink, :meta_description, :meta_keywords,
                   :shipping_category, :options, :weight, :height, :width,
                   :depth, :created_at, :updated_at, :taxons, :meta_data

        has_many :images, serializer: Spree::Wombat::ImageSerializer

        def created_at
          object.created_at.getutc.try(:iso8601)
        end

        def updated_at
          object.updated_at.getutc.try(:iso8601)
        end

        def id
          object.sku
        end

        def price
          object.price.to_f
        end

        def cost_price
          object.cost_price.to_f
        end

        def available_on
          object.available_on.try(:iso8601)
        end

        def permalink
          object.slug
        end

        def shipping_category
          object.shipping_category.name
        end

        def options
          object.option_types.pluck(:name)
        end

        def taxons
          object.taxons.collect {|t| t.self_and_ancestors.collect(&:name)}
        end

        def meta_data
          {
            :jirafe => ActiveModel::ArraySerializer.new(object.taxons,
              each_serializer: Spree::Wombat::Jirafe::TaxonSerializer,
              root: "taxons"
            )
          }
        end
      end

    end
  end
end
