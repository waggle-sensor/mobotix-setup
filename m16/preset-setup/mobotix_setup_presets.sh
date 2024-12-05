#!/bin/bash

# Script to set preset angles on Mobotix M16 via HTTP POST commands with preset movements and actions.

# Ensure the script exits on any error
set -euo pipefail

# Check if an IP address was provided
if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <camera_IP>"
    exit 1
fi

# Input arguments
cam_IP="$1"

# Base command for sending control instructions
base_command="curl -u admin:wagglesage -X POST http://$cam_IP/control/rcontrol?action=putrs232&rs232outtext="

# Define camera movement codes
# Add comments to explain each category for readability

# Upward movements
up_s1="%FF%01%00%08%00%01%0A"
up_s2="%FF%01%00%08%00%0F%18"
up_s3="%FF%01%00%08%00%1F%28"
up_s4="%FF%01%00%08%00%2F%38"
up_s5="%FF%01%00%08%00%FF%08"

# Downward movements
down_s1="%FF%01%00%10%00%01%12"
down_s2="%FF%01%00%10%00%0F%20"
down_s3="%FF%01%00%10%00%1F%30"
down_s4="%FF%01%00%10%00%2F%40"
down_s5="%FF%01%00%10%00%FF%10"

# Rightward movements
right_s1="%FF%01%00%02%01%00%04"
right_s2="%FF%01%00%02%0F%00%12"
right_s3="%FF%01%00%02%1F%00%22"
right_s4="%FF%01%00%02%2F%00%32"
right_s5="%FF%01%00%02%FF%00%02"

# Leftward movements
left_s1="%FF%01%00%04%01%00%06"
left_s2="%FF%01%00%04%0F%00%14"
left_s3="%FF%01%00%04%1F%00%24"
left_s4="%FF%01%00%04%2F%00%34"
left_s5="%FF%01%00%04%FF%00%04"

# Other commands
stop="%FF%01%00%00%00%00%01"
reset="%FF%01%00%0F%00%00%10"

# Preset tour save and call commands 
tour_rec_start_1="%FF%01%00%1F%00%00%20"
tour_rec_start_2="%FF%01%00%1F%00%01%21"
tour_rec_start_3="%FF%01%00%1F%00%02%22"
tour_rec_start_4="%FF%01%00%1F%00%03%23"
tour_rec_stop_1="%FF%01%00%21%00%00%22"
tour_rec_stop_2="%FF%01%00%21%00%01%23"
tour_rec_stop_3="%FF%01%00%21%00%02%24"
tour_rec_stop_4="%FF%01%00%21%00%03%25"
tour_start_1="%FF%01%00%23%00%00%24"
tour_start_2="%FF%01%00%23%00%01%25"
tour_start_3="%FF%01%00%23%00%02%26"
tour_start_4="%FF%01%00%23%00%03%27"
save_preset_1="%FF%01%00%03%00%01%05"
save_preset_2="%FF%01%00%03%00%02%06"
save_preset_3="%FF%01%00%03%00%03%07"
save_preset_4="%FF%01%00%03%00%04%08"
save_preset_5="%FF%01%00%03%00%05%09"
save_preset_6="%FF%01%00%03%00%06%0A"
save_preset_7="%FF%01%00%03%00%07%0B"
save_preset_8="%FF%01%00%03%00%08%0C"
save_preset_9="%FF%01%00%03%00%09%0D"
save_preset_10="%FF%01%00%03%00%10%14"
save_preset_11="%FF%01%00%03%00%11%15"
save_preset_12="%FF%01%00%03%00%12%16"
save_preset_13="%FF%01%00%03%00%13%17"
save_preset_14="%FF%01%00%03%00%14%18"
save_preset_15="%FF%01%00%03%00%15%19"
save_preset_16="%FF%01%00%03%00%16%1A"
save_preset_17="%FF%01%00%03%00%17%1B"
save_preset_18="%FF%01%00%03%00%18%1C"
save_preset_19="%FF%01%00%03%00%19%1D"
save_preset_20="%FF%01%00%03%00%20%24"
save_preset_21="%FF%01%00%03%00%21%25"
save_preset_22="%FF%01%00%03%00%22%26"
save_preset_23="%FF%01%00%03%00%23%27"
save_preset_24="%FF%01%00%03%00%24%28"
save_preset_25="%FF%01%00%03%00%25%29"
save_preset_26="%FF%01%00%03%00%26%2A"
save_preset_27="%FF%01%00%03%00%27%2B"
save_preset_28="%FF%01%00%03%00%28%2C"
save_preset_29="%FF%01%00%03%00%29%2D"
save_preset_30="%FF%01%00%03%00%30%34"
save_preset_31="%FF%01%00%03%00%31%35"
save_preset_32="%FF%01%00%03%00%32%36"
call_preset_1="%FF%01%00%07%00%01%09"
call_preset_2="%FF%01%00%07%00%02%0A"
call_preset_3="%FF%01%00%07%00%03%0B"
call_preset_4="%FF%01%00%07%00%04%0C"
call_preset_5="%FF%01%00%07%00%05%0D"
call_preset_6="%FF%01%00%07%00%06%0E"
call_preset_7="%FF%01%00%07%00%07%0F"
call_preset_8="%FF%01%00%07%00%08%10"
call_preset_9="%FF%01%00%07%00%09%11"
call_preset_10="%FF%01%00%07%00%10%18"
call_preset_11="%FF%01%00%07%00%11%19"
call_preset_12="%FF%01%00%07%00%12%1A"
call_preset_13="%FF%01%00%07%00%13%1B"
call_preset_14="%FF%01%00%07%00%14%1C"
call_preset_15="%FF%01%00%07%00%15%1D"
call_preset_16="%FF%01%00%07%00%16%1E"
call_preset_17="%FF%01%00%07%00%17%1F"
call_preset_18="%FF%01%00%07%00%18%20"
call_preset_19="%FF%01%00%07%00%19%21"
call_preset_20="%FF%01%00%07%00%20%28"
call_preset_21="%FF%01%00%07%00%21%29"
call_preset_22="%FF%01%00%07%00%22%2A"
call_preset_23="%FF%01%00%07%00%23%2B"
call_preset_24="%FF%01%00%07%00%24%2C"
call_preset_25="%FF%01%00%07%00%25%2D"
call_preset_26="%FF%01%00%07%00%26%2E"
call_preset_27="%FF%01%00%07%00%27%2F"
call_preset_28="%FF%01%00%07%00%28%30"
call_preset_29="%FF%01%00%07%00%29%31"
call_preset_30="%FF%01%00%07%00%30%38"
call_preset_31="%FF%01%00%07%00%31%39"
call_preset_32="%FF%01%00%07%00%32%3A"

# Function to send a command
send_command() {
    local command="$1"
    echo "Sending command: $command"
    $base_command"$command" || {
        echo "Error: Failed to send command: $command"
        exit 1
    }
    sleep 1
}

# Reset camera to starting position
echo "Resetting camera..."
send_command "$reset"
sleep 60  # Allow time for reset

echo "Starting script..."

# Initial movement
send_command "$right_s2"
send_command "$up_s5"
sleep 10
send_command "$stop"
echo "Reached topmost position."

# Move downward and save preset locations
send_command "$down_s2"
sleep 7
send_command "$stop"
echo "Reached initial location."

# Loop through positions and save presets
for k in {0..3}; do
    for i in {1..4}; do
        if [[ $i -gt 1 ]]; then
            send_command "$down_s2"
            sleep 7
            send_command "$stop"
        fi

        preset_var="save_preset_$((8 * k + i))"
        preset_command="${!preset_var:-}"
        if [[ -n $preset_command ]]; then
            echo "Saving preset $preset_var"
            send_command "$preset_command"
        else
            echo "Warning: Undefined preset $preset_var"
        fi
    done

    # Move right after saving presets
    send_command "$right_s2"
    sleep 10.55
    send_command "$stop"

    # Reverse movement and save additional presets
    for i in {8..5}; do
        if [[ $i -lt 8 ]]; then
            send_command "$up_s2"
            sleep 7
            send_command "$stop"
        fi

        preset_var="save_preset_$((8 * k + i))"
        preset_command="${!preset_var:-}"
        if [[ -n $preset_command ]]; then
            echo "Saving preset $preset_var"
            send_command "$preset_command"
        else
            echo "Warning: Undefined preset $preset_var"
        fi
    done

    # Move right again
    send_command "$right_s2"
    sleep 10.55
    send_command "$stop"
done

echo "Script completed successfully."
exit 0
