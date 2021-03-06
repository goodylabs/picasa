require "picasa/api/base"

module Picasa
  module API
    class Album < Base
      # Returns album list
      #
      # @param [Hash] options additional options included in request
      # @option options [all, private, public, visible] :access which data should be retrieved when authenticated
      # @option options [String] :fields which fields should be retrieved https://developers.google.com/gdata/docs/2.0/reference#PartialResponseRequest
      # @option options [String, Integer] :max_results how many albums response should include
      # @option options [String, Integer] :start_index 1-based index of the first result to be retrieved
      #
      # @return [Presenter::AlbumList]
      def list(options = {})
        path = "/data/feed/api/user/#{user_id}"
        response = Connection.new.get(path: path, query: options, headers: auth_header)

        Presenter::AlbumList.new(response.parsed_response["feed"])
      end

      # Returns photo list for given album
      #
      # @param [String] album_id album id
      # @param [Hash] options additional options included in request
      # @param [String] imgmax size of image in media content  values are 94, 110, 128, 200, 220, 288, 320, 400, 512, 576, 640, 720, 800, 912, 1024, 1152, 1280, 1440, 1600, d(FullSizeImage)
      # @option options [String] :fields which fields should be retrieved https://developers.google.com/gdata/docs/2.0/reference#PartialResponseRequest
      # @option options [String, Integer] :max_results max number of returned results
      # @option options [String] :tag include photos with given tag only
      #
      # @return [Presenter::Album]
      # @raise [NotFoundError] raised when album cannot be found
      def show(album_id, imgmax=600, options = {})
        path = "/data/feed/api/user/#{user_id}/albumid/#{album_id}?imgmax=#{imgmax}"
        response = Connection.new.get(path: path, query: options, headers: auth_header)

        Presenter::Album.new(response.parsed_response["feed"])
      end

      # Creates album
      #
      # @param [Hash] params album parameters
      # @option options [String] :title title of album (required)
      # @option options [String] :summary summary of album
      # @option options [String] :location location of album photos (i.e. Poland)
      # @option options [String] :access ["public", "private", "protected"] (default to private)
      # @option options [String] :timestamp timestamp of album (default to now)
      # @option options [String] :keywords keywords (i.e. "vacation, poland")
      # @return [Presenter::Album]
      def create(params = {})
        params[:title] || raise(ArgumentError, "You must specify title")
        # API takes timestamp with milliseconds
        params[:timestamp] = (params[:timestamp] || Time.now.to_i) * 1000
        params[:access] ||= "private"

        template = Template.new(:new_album, params)
        path = "/data/feed/api/user/#{user_id}"
        response = Connection.new.post(path: path, body: template.render, headers: auth_header)

        Presenter::Album.new(response.parsed_response["entry"])
      end

      # Destroys given album
      #
      # @param [String] album_id album id
      # @param [Hash] options request parameters
      # @option options [String] :etag destroys only when ETag matches - protects before destroying other client changes
      #
      # @return [true]
      # @raise [NotFoundError] raised when album cannot be found
      # @raise [PreconditionFailedError] raised when ETag does not match
      def destroy(album_id, options = {})
        headers = auth_header.merge({"If-Match" => options.fetch(:etag, "*")})
        path = "/data/entry/api/user/#{user_id}/albumid/#{album_id}"
        Connection.new.delete(path: path, headers: headers)
        true
      end
      alias :delete :destroy
    end
  end
end
