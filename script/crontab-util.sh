
if [[ "$1" == "list" ]]; then
  arr=()
  if [ -f /etc/cron.weekly/rsnapshot ]; then
    arr+=('weekly')
  fi
  if [ -f /etc/cron.monthly/rsnapshot ]; then
    arr+=('monthly')
  fi
  if [ -f /etc/cron.daily/rsnapshot ]; then
    arr+=('daily')
  fi
  echo "${arr[@]}"

elif [[ "$1" == "reset" ]]; then
  if [ -f /etc/cron.weekly/rsnapshot ]; then
    rm /etc/cron.weekly/rsnapshot
  fi
  if [ -f /etc/cron.monthly/rsnapshot ]; then
    rm /etc/cron.monthly/rsnapshot
  fi
  if [ -f /etc/cron.daily/rsnapshot ]; then
    rm /etc/cron.daily/rsnapshot
  fi

elif [[ "$1" == "add" ]]; then
if [[ "$2" == "weekly" ]]; then
cat > /etc/cron.weekly/rsnapshot << 'EOF'
#!/bin/sh
rsnapshot weekly
EOF
chmod +x /etc/cron.weekly/rsnapshot

elif [[ "$2" == "monthly" ]]; then
cat > /etc/cron.monthly/rsnapshot << 'EOF'
#!/bin/sh
rsnapshot monthly
EOF
chmod +x /etc/cron.monthly/rsnapshot

else
cat > /etc/cron.daily/rsnapshot << 'EOF'
#!/bin/sh
rsnapshot daily
EOF
chmod +x /etc/cron.daily/rsnapshot

fi

elif [[ "$1" == "remove" ]]; then
  if [[ "$2" == "weekly" ]]; then
    rm /etc/cron.weekly/rsnapshot
  elif [[ "$2" == "monthly" ]]; then
    rm /etc/cron.monthly/rsnapshot
  elif [[ "$2" == "daily" ]]; then
    rm /etc/cron.daily/rsnapshot
  fi
fi
