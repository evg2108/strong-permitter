require 'spec_helper'
require 'action_controller'

class TestController < ActionController::Base
  include StrongPermitter::Manager

  def create
    self.action_name = :create
    @allowed_params = permitted_params
  end

  def update
    self.action_name = :update
    @allowed_params = permitted_params
  end

  def test_action
    self.action_name = :test_action
    @allowed_params = permitted_params
  end
end

class TestPermission < StrongPermitter::Permission::Base
  create_params :arg1, :arg2
  update_params :arg3, :arg4, resource: :another_resource
end

Hash.send(:alias_method, :require, :[])
class Array
  def permit(*args)
    self && args
  end
end

describe StrongPermitter::Manager do
  subject { TestController.new }

  describe '#permitted_params' do
    before(:example) do
      subject.params = { test: [ :arg1, :arg2, :other_arg ], another_resource: [ :arg3, :arg4, :other_arg ], another_resource2: [:arg5, :arg6, :arg7] }
    end

    context 'when :resource argument not set and resource_name not set' do
      it 'calls params.require(controller_name.singularize).permit(*arguments_array)' do
        subject.create
        expect(subject.instance_variable_get(:@allowed_params)).to eq([:arg1, :arg2])
      end
    end

    context 'when :resource argument is set and resource_name not set' do
      it 'calls params.require(<resource>).permit(*arguments_array)' do
        subject.update
        expect(subject.instance_variable_get(:@allowed_params)).to eq([:arg3, :arg4])
      end
    end

    # context 'when resource_name is set' do
    #   context 'and :resource argument not set' do
    #     subject { TestController.new }
    #     before(:example) do
    #       TestPermission.resource_name = :another_resource2
    #     end
    #
    #     it 'calls params.require(resource_name).permit(*arguments_array)' do
    #       subject.create
    #       expect(subject.instance_variable_get(:@allowed_params)).to eq([:arg5, :arg6])
    #     end
    #   end
    # end
  end
end