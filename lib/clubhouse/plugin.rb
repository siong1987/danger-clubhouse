module Danger
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

    # Check the branch and commit messages to find clubhouse stories to link to.
    #
    # @return [void]
    def link_stories!
      clubhouse_story_ids = []

      # Check for the branch
      if (story_id = find_story_id(github.branch_for_head))
        clubhouse_story_ids << story_id
      end

      # Check all the commit messages
      messages.each do |message|
        if (story_id = find_story_id(message))
          clubhouse_story_ids << story_id
        end
      end

      post!(clubhouse_story_ids) unless clubhouse_story_ids.empty?
    end

    # Find clubhouse story id in the body
    #
    # @return [String, nil]
    def find_story_id(body)
      if (match = body.match(/ch(\d+)/))
        return match[1]
      end

      nil
    end

    private

    def post!(story_ids)
      message = "### Clubhouse Stories\n\n"
      story_ids.each do |id|
        message << "* [https://app.clubhouse.io/#{organization}/story/#{id}](https://app.clubhouse.io/#{organization}/story/#{id}) \n"
      end
      markdown message
    end

    def messages
      git.commits.map(&:message)
    end
  end
end
