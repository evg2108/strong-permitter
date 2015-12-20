require 'spec_helper'
require 'active_support/hash_with_indifferent_access'

describe StrongPermitter::Permission::Base do
  subject { StrongPermitter::Permission::Base }

  before(:example) do
    subject.actions.keys.each { |key| subject.actions.delete(key) }
  end

  describe '.actions' do
    context 'with not existed key' do
      it 'returns hash with empty array for :permitted_params key' do
        expect(subject.actions[:test][:permitted_params]).to eq([])
      end
    end
  end

  describe '.resource_name=' do
    let(:test_val){ :test }

    it 'assigns resource_name' do
      subject.resource_name = test_val
      expect(subject.resource_name).to eq(test_val)
    end
  end

  describe '.create_params' do
    let(:params) { [:arg1, :arg2, :arg3, resource: :test_resource] }
    it 'calls allowed_params_for with :create in first param' do
      is_expected.to receive(:allowed_params_for).with(:create, *params)
      subject.create_params(*params)
    end
  end

  describe '.update_params' do
    let(:params) { [:arg1, :arg2, :arg3, resource: :test_resource] }
    it 'calls allowed_params_for with :update in first param' do
      is_expected.to receive(:allowed_params_for).with(:update, *params)
      subject.update_params(*params)
    end
  end

  describe '.allowed_params_for' do
    let(:test_action_name) { :test_action }
    let(:params) { [:arg1, :arg2, :arg3] }

    context 'with :resource last argument' do
      let(:resource_arg) { { resource: :test_resource } }

      it 'assigns actions[<first argument>] with hash contains params in :permitted_params key and resource name in :resource key' do
        subject.allowed_params_for test_action_name, *(params + [resource_arg])
        expect(subject.actions[test_action_name]).to eq({ permitted_params: params, resource: resource_arg[:resource] })
      end
    end

    context 'without :resource last argument' do
      it 'assigns actions[<first argument>] with hash contains params in :permitted_params key' do
        subject.allowed_params_for test_action_name, *params
        expect(subject.actions[test_action_name]).to eq({ permitted_params: params })
      end
    end
  end
end