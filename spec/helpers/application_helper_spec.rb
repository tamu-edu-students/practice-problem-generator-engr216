require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe '#format_answer' do
    context 'when input is valid JSON' do
      let(:json_string) { { mean: 2.5, median: 2.5 }.to_json }

      it 'formats the JSON data as a readable HTML list' do
        expected_html = '<strong>Mean:</strong> 2.5<br><strong>Median:</strong> 2.5'
        expect(helper.format_answer(json_string)).to eq(expected_html)
      end
    end

    context 'when input looks like JSON but is invalid' do
      let(:invalid_json_string) { '{ mean: 2.5, ' } # Missing closing brace and quotes

      it 'returns the escaped original string' do
        expect(helper.format_answer(invalid_json_string)).to eq(ERB::Util.html_escape(invalid_json_string))
      end
    end

    context 'when input is not JSON' do
      let(:plain_string) { 'Just a regular string.' }

      it 'returns the escaped original string' do
        expect(helper.format_answer(plain_string)).to eq(ERB::Util.html_escape(plain_string))
      end
    end

    context 'when input contains HTML characters' do
      let(:html_string) { '<p>This is HTML</p>' }

      it 'returns the escaped original string' do
        expect(helper.format_answer(html_string)).to eq(ERB::Util.html_escape(html_string))
      end
    end

    context 'when a standard error occurs during formatting' do
      let(:json_string) { { mean: 2.5 }.to_json }

      before do
        # Stub JSON.parse to raise a StandardError instead of JSON::ParserError
        allow(JSON).to receive(:parse).and_raise(StandardError, 'Something went wrong')
      end

      it 'returns the escaped original string' do
        expect(helper.format_answer(json_string)).to eq(ERB::Util.html_escape(json_string))
      end
    end
  end
end
