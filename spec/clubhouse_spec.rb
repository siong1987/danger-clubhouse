require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe Danger::DangerClubhouse do
    it 'should be a plugin' do
      expect(Danger::DangerClubhouse.new(nil)).to be_a Danger::Plugin
    end

    #
    # You should test your custom attributes and methods here
    #
    describe 'with Dangerfile' do
      let(:dangerfile) { testing_dangerfile }
      let(:clubhouse) do
        dangerfile.clubhouse.organization = 'organization'
        dangerfile.clubhouse
      end
      let(:status_report) { clubhouse.status_report }

      context 'link_stories!' do
        let(:branch) { 'new_branch' }
        let(:body) { 'new body' }

        subject do
          clubhouse.link_stories!
        end

        before do
          commit = double(:commit, message: body)
          allow(clubhouse.git).to receive(:commits).and_return([commit])

          allow(clubhouse.github).to receive(:branch_for_head).and_return(branch)
        end

        context 'in commit' do
          context 'with story id' do
            let(:body) { 'This is cool [ch345]' }

            it 'links the story' do
              subject

              expect(status_report[:markdowns].map(&:message)).to eq [
                "### Clubhouse stories\n\n[https://app.clubhouse.io/organization/stories/345](https://app.clubhouse.io/organization/stories/345) \n"
              ]
            end
          end

          context 'without story id' do
            let(:body) { 'This is cool' }

            it 'links to no stories' do
              subject

              expect(status_report[:markdowns].map(&:message)).to eq []
            end
          end
        end

        context 'in branch' do
          context 'with story id' do
            let(:branch) { 'siong/ch345/cool-fix' }

            it 'links the story' do
              subject

              expect(status_report[:markdowns].map(&:message)).to eq [
                "### Clubhouse stories\n\n[https://app.clubhouse.io/organization/stories/345](https://app.clubhouse.io/organization/stories/345) \n"
              ]
            end
          end

          context 'without story id' do
            let(:branch) { 'siong/cool-fix' }

            it 'links to no stories' do
              subject

              expect(status_report[:markdowns].map(&:message)).to eq []
            end
          end
        end
      end

      context 'find_story_id' do
        subject do
          clubhouse.find_story_id(body)
        end

        context 'with proper story id in body' do
          let(:body) { 'This is cool [ch345]' }

          it 'finds the story id' do
            expect(subject).to eq('345')
          end
        end

        context 'without story id in body' do
          let(:body) { 'This is cool' }

          it 'returns nil' do
            expect(subject).to eq(nil)
          end
        end
      end
    end
  end
end
