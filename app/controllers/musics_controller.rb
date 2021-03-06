class MusicsController < ApplicationController
  before_action :signed_in_user
  before_action :set_music, only: [:edit, :update, :destroy]

  # GET /musics
  # GET /musics.json
  def index
    @musics = Music.all
  end

  # GET /musics/1
  # GET /musics/1.json
  def show
    begin
      @music = Music.find(params[:id])
      users_mark = @current_user.users_marks.find_by_music_id params[:id]
      mark = 0
      if users_mark
        mark = users_mark.mark
      end
      artist = @music.artist
      album = @music.album
      musicInfo = {
        id: @music.id,
        name: @music.name,
        resource_id: 0,
        music_id: @music.music_id,
        location: @music.location,
        lyric: @music.lyric,
        artist_id: artist.artist_id,
        artist_name: artist.name,
        album_id: album.album_id,
        album_name: album.name,
        cover_url: album.cover_url,
        mark: mark
      }
      @result = {
        status:"ok",
        music: musicInfo
      }
    rescue ActiveRecord::RecordNotFound
      @result = {
        status:"failed",
        msg:"Can't find the music"
      }
    end
  end

  # GET /musics/new
  def new
    @music = Music.new
  end

  # GET /musics/1/edit
  def edit
  end

  # POST /musics
  # POST /musics.json
  def create
    @music = Music.new(music_params)

    respond_to do |format|
      if @music.save
        format.html { redirect_to @music, notice: 'Music was successfully created.' }
        format.json { render action: 'show', status: :created, location: @music }
      else
        format.html { render action: 'new' }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /musics/1
  # PATCH/PUT /musics/1.json
  def update
    respond_to do |format|
      if @music.update(music_params)
        format.html { redirect_to @music, notice: 'Music was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @music.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /musics/1
  # DELETE /musics/1.json
  def destroy
    @music.destroy
    respond_to do |format|
      format.html { redirect_to musics_url }
      format.json { head :no_content }
    end
  end

  def like
    current_user.like Music.find(params[:id])
    render json:{status:"ok"}
  end

  def dislike
    current_user.dislike Music.find(params[:id])
    render json:{status:"ok"}
  end

  def unmark
    current_user.unmark Music.find(params[:id])
    render json:{status:"ok"}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_music
      @music = Music.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def music_params
      params.require(:music).permit(:name, :resource_id, :music_id, :location, :artist_id, :album_id)
    end
    
end
