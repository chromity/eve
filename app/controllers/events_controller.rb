class EventsController < ApplicationController
  before_action :login_required

  def new
  end

  def index
    @event = Event.new

    if session[:user]
      city = User.where("id=?", session[:user_id]).limit(1).pluck(:city)
      @events = Event.where(["city = ?", city]).order(created_at: :desc)
      @events_all = Event.where(["city <> ?", city]).order(created_at: :desc).paginate(page: params[:page], per_page: 5)
    else
      redirect_to "/sessions/new"
    end
  end

  def location
    @events = Event.all.order(city: :asc).paginate(page: params[:page], per_page: 10)
  end

  def create
    @user = User.find(session[:user_id])
    @event = @user.events.new(event_params)
    @event.city = params[:city]
    @event.date = params[:date]

    if @event.save
      flash[:notice] = "Event sucessfully created"
      flash[:color] = "success"
      redirect_to "/events"
    else
      flash[:errors] = @event.errors.full_messages
      redirect_to "/events"
    end
  end

  def join
    @userevent = UserEvent.new(userevent_params)
    @userevent.save
    flash[:notice] = "You successfully joined event"
    flash[:color] = "info"
    redirect_to '/'
  end

  def cancel
    user = User.find(userevent_params["user_id"])
    event = user.events.find(userevent_params["event_id"])

    if event
      user.events.delete(event)
      flash[:notice] = "You sucessfully deleted event"
      flash[:color] = "info"
      redirect_to '/'
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.date = params[:date]
    @event.city = params[:city]
    result = @event.update_attributes(event_params)
    if result
      redirect_to "/events"
      flash[:notice] = "Event successfully updated"
      flash[:color] = "success"
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event
      @event.destroy
      flash[:notice] = "Event successfully deleted"
      flash[:color] = "warning"
      redirect_to '/events'
    else
      redirect_to '/events'
    end
  end

  def show
    @event = Event.find(params[:id])
  end


  private

  def event_params
    params.require(:event).permit(:name, :date, :location, :city, :host)
  end

  def userevent_params
    params.require(:userevent).permit(:user_id, :event_id)
  end
end
