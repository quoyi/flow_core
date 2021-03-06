# frozen_string_literal: true

module FormKit::Fields
  class ResourcePresenter < FormKit::FieldPresenter
    def value_for_preview
      return unless @model.collection

      id = value
      return if id.blank?

      collection
        .where(@model.data_source.value_method => id)
        .first
        &.send(@model.data_source.text_method)
    end

    def include_blank?
      required?
    end

    def collection
      return unless @model.collection
      return if @model.collection.none?

      # TODO: limit 100 for performance
      @model.collection.limit(100)
    end

    def options_for_select
      unless collection
        return @view.options_for_select([])
      end

      @view.options_from_collection_for_select(
        collection, @model.data_source.value_method, @model.data_source.text_method, value
      )
    end
  end
end
