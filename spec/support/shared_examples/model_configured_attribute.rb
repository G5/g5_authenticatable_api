# frozen_string_literal: true

require 'spec_helper'

shared_examples_for 'a module configured attribute' do |attribute_name,default_value|

  describe "##{attribute_name.to_s}=" do
    subject do
      client.send "#{attribute_name.to_s}=", new_value
      client
    end

    context "with nil #{attribute_name.to_s}" do
      let(:new_value){nil}

      context "with module configured #{attribute_name}" do
        let(:configured_value){'other thing'}

        before do
          G5AuthenticatableApi.configure do |t|
            t.send "#{attribute_name.to_s}=", configured_value
          end
        end

        it "should have correct #{attribute_name}" do
          expect(subject.send(attribute_name)).to eq(configured_value)
        end

      end

      context 'without module configured #{attribute_name}' do

        it "should have correct #{attribute_name}" do
          expect(subject.send(attribute_name)).to eq(default_value)
        end
      end
    end

    context 'with new #{attribute_name.to_s}' do
      let(:new_value){ 'userdude' }

      it "should have correct #{attribute_name}" do
        expect(subject.send(attribute_name)).to eq(new_value)
      end
    end
  end
end
