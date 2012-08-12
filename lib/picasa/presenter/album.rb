module Picasa
  module Presenter
    class Album
      include Utils

      attr_reader :parsed_body

      def initialize(parsed_body)
        @parsed_body = parsed_body
      end

      def author
        @author ||= Author.new(safe_retrieve(parsed_body, "author"))
      end

      def published
        @published ||= safe_retrieve(parsed_body, "published")
      end

      def updated
        @updated ||= safe_retrieve(parsed_body, "updated")
      end

      def title
        @title ||= safe_retrieve(parsed_body, "title")
      end

      def summary
        @summary ||= safe_retrieve(parsed_body, "summary")
      end

      def rights
        @rights ||= safe_retrieve(parsed_body, "rights")
      end

      def id
        @id ||= safe_retrieve(parsed_body, "gphoto:id")
      end

      def name
        @name ||= safe_retrieve(parsed_body, "gphoto:name")
      end

      def location
        @location ||= safe_retrieve(parsed_body, "gphoto:location")
      end

      def access
        @access ||= safe_retrieve(parsed_body, "gphoto:access")
      end

      def timestamp
        @timestamp ||= safe_retrieve(parsed_body, "gphoto:timestamp")
      end

      def numphotos
        return @numphotos if defined?(@numphotos)
        if numphotos = safe_retrieve(parsed_body, "gphoto:numphotos")
          @numphotos = numphotos.to_i
        end
      end

      def user
        @user ||= safe_retrieve(parsed_body, "gphoto:user")
      end

      def nickname
        @nickname ||= safe_retrieve(parsed_body, "gphoto:nickname")
      end
    end
  end
end