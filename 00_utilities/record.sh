#!/bin/bash
# Get pulseaudio monitor sink monitor device then pipe it to 
# sox to record wav, lame to encode to mp3, or flac to encode flac
FILENAME="$1"
STOPTIME="$2"
# Encoding options for lame and flac.
LAMEOPTIONS="--preset cbr 192 -s 44.1" 
FLACOPTIONS="--force-raw-format --endian=little --channels=2 --sample-rate=44100 --sign=signed --bps=16 -f"

if [ -z "$FILENAME" ]; then
    echo -e "
    Usage: $0 /path/to/output.wav or output.mp3 or output.flac
    Usage: $0 /path/to/output.wav or output.mp3 or output.flac stopinseconds" >&2
    exit 1
fi

# Get sink monitor:
MONITOR=$(pactl list | egrep -A2 '^(\*\*\* )?Source #' | \
    grep 'Name: .*\.monitor$' | awk '{print $NF}' | tail -n1)
echo "set-source-mute ${MONITOR} false" | pacmd >/dev/null

# Record it raw, and pipe to lame for an mp3
echo "Recording to $FILENAME ..."

if [[ $FILENAME =~ .mp3$ ]]; then
  if [ -z $STOPTIME ]; then
    parec -d $MONITOR | lame $LAMEOPTIONS -r - $FILENAME 
  else
    echo -e "\nStopping in $STOPTIME seconds"
    parec -d $MONITOR | lame $LAMEOPTIONS -r - $FILENAME 2>&1 &
    SPID=$!
    sleep $STOPTIME
    kill -9 $SPID
  fi
fi 

# Note: wav has a limit of about 6.5hrs using 44k 16bit. 
if [[ $FILENAME =~ .wav$ ]]; then
  if [ -z $STOPTIME ]; then
    parec -d "$MONITOR" | sox -t raw -r 44k -sLb 16 -c 2 - "$FILENAME"
  else
    echo -e "\nStopping in $STOPTIME seconds"
    parec -d "$MONITOR" | sox -t raw -r 44k -sLb 16 -c 2 - "$FILENAME" trim 0 $STOPTIME
  fi
fi

if [[ $FILENAME =~ .flac$ ]]; then
  if [ -z $STOPTIME ]; then
    parec -d "$MONITOR" | flac - $FLACOPTIONS -o $FILENAME
  else
    echo -e "\nStopping in $STOPTIME seconds"
    parec -d $MONITOR | flac - $FLACOPTIONS -o $FILENAME 2>&1 &
    SPID=$!
    sleep $STOPTIME
    kill -9 $SPID
  fi
fi  
