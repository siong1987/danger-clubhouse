# This is your plugin class. Any attributes or methods you expose here will
# be available from within your Dangerfile.
#
# To be published on the Danger plugins site, you will need to have
# the public interface documented. Danger uses [YARD](http://yardoc.org/)
# for generating documentation from your plugin source, and you can verify
# by running `danger plugins lint` or `bundle exec rake spec`.
#
# You should replace these comments with a public description of your library.
#
# @example Ensure people are well warned about merging on Mondays
#
#          my_plugin.warn_on_mondays
#
# @see  Teng Siong Ong/danger-clubhouse
# @tags monday, weekends, time, rattata
#
module Danger  
  # This plugin will detect stories from clubhouse and link to them.
  #
  # @example Customize the clubhouse organization and check for stories to link to them.
  #
  #          clubhouse.organization = 'organization'
  #          clubhouse.link_stories!
  #
  # @see  siong1987/danger-clubhouse
  # @tags clubhouse
  class DangerClubhouse < Plugin
    # The clubhouse organization name, you must set this!
    #
    # @return   [String]
    attr_accessor :organization

    # Check the branch, commit messages, comments and description to find clubhouse stories to link to.
    #
    # @return [void]
    def link_stories!      
      story_ids = find_all_story_ids
      return if story_ids.empty?

      message = "### Clubhouse Stories\n\n"
      story_ids.each do |id|
        message << "* [#{story_link(id)}](#{story_link(id)}) \n"
      end      
      markdown message
    end
    
    # Find clubhouse story ids in the text.
    #
    # @return [Array<String>]
    def find_story_ids(text)
      text.scan(/ch(\d+)/).flatten
    end
    
    # Find clubhouse story id in the text.
    #
    # @return [String, nil]
    def find_story_id(text)
      find_story_ids(text).first
    end

    private

    def find_story_ids_in_branch
      find_story_ids(github.branch_for_head) if defined? @dangerfile.github
    end

    def find_story_ids_in_commits
      git.commits.map { |commit| find_story_ids(commit.message) }.flatten
    end
    
    def find_story_ids_in_description
      find_story_ids(github.pr_body) if defined? @dangerfile.github
    end

    def find_story_ids_in_comments
      if defined? @dangerfile.github
        github
          .api
          .issue_comments(github.pr_json.head.repo.id, github.pr_json.number)
          .map { |comment| find_story_ids(comment.body) }
          .flatten
      end
    end
    
    def find_all_story_ids
      find_story_ids_in_branch + find_story_ids_in_commits + find_story_ids_in_description + find_story_ids_in_comments
    end
      
    def story_link(id)
      "https://app.clubhouse.io/#{organization}/story/#{id}"
    end
  end
end