class ReservationsController < ApplicationController
  # Get All Reservations With Status Pending
  def pending_reservation_admin
    if admin?
      pending_reservations = Reservation.all.where(status: 'Pending')
      render json: pending_reservations, each_serializer: ReservationSerializer
    else
      render json: { error: 'Not Allowed' }, status: :unauthorized
    end
  end

  # Update a Reservation Based On Admin Decision
  def handle_pending_reservation_admin
    if admin?
      reservation = Reservation.find_by(id: action_params[:reservation_id].to_i)
      raise ActiveRecord::RecordNotFound unless reservation

      case action_params[:decision]
      when 'Confirm'
        update_reservation(reservation, 'Confirmed')
      when 'Refuse'
        update_reservation(reservation, 'Refused')
      end
    else
      render json: { error: 'Not Allowed' }, status: :unauthorized
    end
  end

  private

  # If Admin Approve Update reservation status
  def update_reservation(reservation, decision)
    reservation.status = decision
    if reservation.save
      create_notification(reservation)
      render json: reservation, each_serializer: ReservationSerializer
    else
      render json: { error: 'Bad Request' }, status: :not_acceptable
    end
  end

  # After every decision Add Notification to database & Send Email
  def create_notification(reservation)
    current_user.notifier.create(recipient_id: reservation.user_id, admin_id: current_user.id,
                                 text: action_params[:text], reserve_id: reservation.id)
    # Send Email Later
  end

  def action_params
    params.permit(:reservation_id, :decision, :text)
  end
end
