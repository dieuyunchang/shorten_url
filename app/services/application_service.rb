# frozen_string_literal: true

# ApplicationService is an abstract service class
# Every service class has only 1 responsibility, is triggered by `#call` method
# ApplicationService creates the `self.call` method to abstract the constructor
# task.
#
# `#call` method definitions must always return a ApplicationService::Result
# private method `#create_result` is implemented as a convenient way to create
# ApplicationService::Result instances
#
# @args arguments needed to construct the service object
#       can be any type
#
# @example
#    # Without custom service result
#
#    class AService < ApplicationService
#      def initialize(n)
#        @n = n
#      end
#
#      def call
#        # do stuff
#        return error("Something went wrong") unless all_ok?
#        ...
#        return success
#      end
#
#      private
#
#      attr_reader :n
#
#      def all_ok?
#        n.even?
#      end
#    end
#
#    ## Usage
#
#    ### Success Case
#    AService.call(4) #=> result object
#    AService.call(4).successful? #=> true
#    AService.call(4).failed? #=> false
#    AService.call(4).errors.blank? #=> true
#
#    ### Failure Case
#    AService.call(5).successful? #=> false
#    AService.call(5).failed? #=> true
#    AService.call(5).errors.full_messages #=> ["Something went wrong"]
#
#    # With custom service result
#
#    class BService < ApplicationService
#      # set attr_accessors for #number and #lol on the result object
#      result :number, :lol
#
#      def initialize(n)
#        @n = n
#      end
#
#      def call
#        return error("Something went wrong", number: n) unless all_ok?
#        puts @n
#        return success(number: n)
#      end
#
#      private
#
#      attr_reader :n
#
#      def all_ok?
#        n.even?
#      end
#    end
#
#    ## Usage
#
#    ### Success Case
#    BService.call(4) #=> result object
#    BService.call(4).successful? #=> true
#    BService.call(4).failed? #=> false
#    BService.call(4).errors.blank? #=> true
#    BService.call(4).number #=> 4
#    BService.call(4).lol #=> nil
#
#    ### Failure Case
#    BService.call(5) #=> result object
#    BService.call(5).successful? #=> false
#    BService.call(5).failed? #=> true
#    BService.call(5).errors.full_messages #=> ["Something went wrong"]
#    BService.call(5).number #=> 5
#    BService.call(4).lol #=> nil
#
# Check out the spec file for more examples.

class ApplicationService
  class << self
    def result(*attributes)
      attributes = [:errors] + attributes

      @result_struct = Struct.new(*attributes) do
        def successful?
          errors.blank?
        end

        def failed?
          !successful?
        end
      end
    end

    def create_result(**result_attributes)
      struct_params = result_struct.members.map { |attribute| result_attributes[attribute] }

      result_struct.new(*struct_params)
    end

    def call(*args, **kwargs, &block)
      new(*args, **kwargs).call(&block)
    end

    protected

    def result_struct
      @result_struct || ApplicationService.result_struct
    end
  end

  result

  def initialize(*); end

  def call
    raise NotImplementedError
  end

  private

  def success(**result_attributes)
    errors = ActiveModel::Errors.new(itself)
    self.class.create_result(**result_attributes.merge(errors: errors))
  end

  def error(*error_messages, **result_attributes)
    errors = ActiveModel::Errors.new(itself)
    error_messages.flatten.each { |message| errors.add(:base, message) }
    self.class.create_result(**result_attributes.merge(errors: errors))
  end
end
