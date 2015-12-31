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
  create_params :arg1, :arg2, :arg5, :arg6
  update_params :arg3, :arg4, resource: :another_resource
end

describe StrongPermitter::Manager do
  subject { TestController.new }

  describe '#permitted_params' do
    before(:example) do
      subject.params = ActionController::Parameters.new({ test: { arg1: 'arg1_val', arg2: 'arg2_val', other_arg: 'other_arg_val' }, another_resource: { arg3: 'arg3_val', arg4: 'arg4_val', other_arg: 'other_arg_val' }, another_resource2: { arg5: 'arg5_val', arg6: 'arg6_val', arg7: 'arg7_val'} })
    end

    context 'when :resource argument not set and resource_name not set' do
      it 'calls params.require(controller_name.singularize).permit(*arguments_array)' do
        subject.create
        expect(subject.instance_variable_get(:@allowed_params)).to eq(HashWithIndifferentAccess.new({arg1: 'arg1_val', arg2: 'arg2_val'}))
      end
    end

    context 'when :resource argument is set and resource_name not set' do
      it 'calls params.require(<resource>).permit(*arguments_array)' do
        subject.update
        expect(subject.instance_variable_get(:@allowed_params)).to eq(HashWithIndifferentAccess.new({arg3: 'arg3_val', arg4: 'arg4_val'}))
      end
    end

    context 'when resource_name is set' do
      context 'and :resource argument not set' do
        before(:example) do
          TestPermission.resource_name = :another_resource2
        end

        it 'calls params.require(resource_name).permit(*arguments_array)' do
          subject.create
          expect(subject.instance_variable_get(:@allowed_params)).to eq(HashWithIndifferentAccess.new({arg5: 'arg5_val', arg6: 'arg6_val'}))
        end
      end

      context 'and :resource argument is set' do
        before(:example) do
          TestPermission.resource_name = :another_resource2
        end

        it 'calls params.require(<resource>).permit(*arguments_array)' do
          subject.update
          expect(subject.instance_variable_get(:@allowed_params)).to eq(HashWithIndifferentAccess.new({arg3: 'arg3_val', arg4: 'arg4_val'}))
        end
      end
    end
  end
end