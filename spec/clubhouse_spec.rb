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
        let(:description) { 'new description' }
        let(:comment_body) { 'new comment body' }
        let(:repo_id) { 'my-username/my-repo' }
        let(:pull_request_number) { 1 }

        subject do
          clubhouse.link_stories!
        end

        before do
          allow(clubhouse.github).to receive_message_chain(:pr_json, :head, :repo, :id).and_return(repo_id)
          allow(clubhouse.github).to receive_message_chain(:pr_json, :number).and_return(pull_request_number)

          commit = double(:commit, message: body)
          allow(clubhouse.git).to receive(:commits).and_return([commit])

          comment = double(:comment, body: comment_body)
          allow(clubhouse.github).to receive_message_chain(:api, :issue_comments).and_return([comment])

          allow(clubhouse.github).to receive(:branch_for_head).and_return(branch)
          allow(clubhouse.github).to receive(:pr_body).and_return(description)
        end

        context 'in commit' do
          context 'with story id' do
            let(:body) { 'This is cool [ch345]' }

            it 'links the story' do
              subject

              expect(status_report[:markdowns].map(&:message)).to eq [
                "### Clubhouse Stories\n\n* [https://app.clubhouse.io/organization/story/345](https://app.clubhouse.io/organization/story/345) \n"
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
                "### Clubhouse Stories\n\n* [https://app.clubhouse.io/organization/story/345](https://app.clubhouse.io/organization/story/345) \n"
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
        
        context 'in description' do
          context 'with story id' do
            let(:description) { '[ch345]' }

            it 'links the story' do
              subject

              expect(status_report[:markdowns].map(&:message)).to eq [
                "### Clubhouse Stories\n\n* [https://app.clubhouse.io/organization/story/345](https://app.clubhouse.io/organization/story/345) \n"
              ]
            end
          end

          context 'without story id' do
            let(:description) { 'Fixed the issue #166.' }

            it 'links to no stories' do
              subject

              expect(status_report[:markdowns].map(&:message)).to eq []
            end
          end
        end

        context 'in comments' do
          context 'with story id' do
            let(:comment_body) { 'Also implements this story [ch345].' }

            it 'links the story' do
              subject

              expect(status_report[:markdowns].map(&:message)).to eq [
                "### Clubhouse Stories\n\n* [https://app.clubhouse.io/organization/story/345](https://app.clubhouse.io/organization/story/345) \n"
              ]
            end
          end

          context 'without story id' do
            let(:comment_body) { 'Good job!' }

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
      
      context 'find_story_ids' do
        subject do
          clubhouse.find_story_ids(body)
        end

        context 'with proper story id in body' do
          let(:body) { 'This is cool [ch345], also [ch346]' }

          it 'finds the story ids' do
            expect(subject).to eq(['345', '346'])
          end
        end

        context 'without story id in body' do
          let(:body) { 'This is cool' }

          it 'returns empty array' do
            expect(subject).to eq([])
          end
        end
      end
    end
  end
end