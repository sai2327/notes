# 18. System Services and Scheduling

## Table of Contents
- [18.1 systemctl — Manage Services](#181-systemctl--manage-services)
- [18.2 journalctl — View Logs](#182-journalctl--view-logs)
- [18.3 Cron Jobs — Schedule Tasks](#183-cron-jobs--schedule-tasks)
- [18.4 at — One-Time Scheduled Tasks](#184-at--one-time-scheduled-tasks)
- [18.5 Practice & Assessment](#185-practice--assessment)

---

## 18.1 systemctl — Manage Services

### What is systemd?
**systemd** is the init system and service manager for most modern Linux distributions. It manages system startup, services, and more.

### Commands

```bash
# ═══════════════════════════════════════
# SERVICE MANAGEMENT
# ═══════════════════════════════════════
# Start a service
sudo systemctl start nginx

# Stop a service
sudo systemctl stop nginx

# Restart a service
sudo systemctl restart nginx

# Reload config without restart
sudo systemctl reload nginx

# Check status
$ systemctl status nginx
● nginx.service - A high performance web server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled)
     Active: active (running) since Mon 2024-01-15 10:00:00 IST
   Main PID: 1234 (nginx)
     Memory: 5.0M
        CPU: 23ms
     CGroup: /system.slice/nginx.service
             ├─1234 nginx: master process
             └─1235 nginx: worker process

# ═══════════════════════════════════════
# ENABLE/DISABLE (boot behavior)
# ═══════════════════════════════════════
# Start service on boot
sudo systemctl enable nginx

# Disable from starting on boot
sudo systemctl disable nginx

# Enable AND start immediately
sudo systemctl enable --now nginx

# Check if enabled
systemctl is-enabled nginx
# Output: enabled

# ═══════════════════════════════════════
# LISTING SERVICES
# ═══════════════════════════════════════
# List all running services
systemctl list-units --type=service --state=running

# List all services (including inactive)
systemctl list-units --type=service --all

# List enabled services
systemctl list-unit-files --type=service --state=enabled

# List failed services
systemctl --failed
```

---

## 18.2 journalctl — View Logs

```bash
# View all logs
journalctl

# Follow logs in real-time (like tail -f)
journalctl -f

# Logs for specific service
journalctl -u nginx
journalctl -u sshd --since today

# Logs since specific time
journalctl --since "2024-01-15 10:00:00"
journalctl --since "1 hour ago"
journalctl --since yesterday

# Show only errors
journalctl -p err
# Priority levels: emerg, alert, crit, err, warning, notice, info, debug

# Boot logs
journalctl -b           # Current boot
journalctl -b -1        # Previous boot

# Disk usage of logs
journalctl --disk-usage

# Clean old logs
sudo journalctl --vacuum-time=7d    # Keep only last 7 days
```

---

## 18.3 Cron Jobs — Schedule Tasks

### What is Cron?
**Cron** is a time-based job scheduler. It runs commands at specified intervals automatically.

### Crontab Format

```
┌───────────── minute (0 - 59)
│ ┌─────────── hour (0 - 23)
│ │ ┌───────── day of month (1 - 31)
│ │ │ ┌─────── month (1 - 12)
│ │ │ │ ┌───── day of week (0 - 7, 0 and 7 = Sunday)
│ │ │ │ │
* * * * *  command_to_execute
```

### Special Characters

| Character | Meaning | Example |
|-----------|---------|---------|
| `*` | Every | `* * * * *` = every minute |
| `,` | List | `1,15,30 * * * *` = at min 1, 15, 30 |
| `-` | Range | `1-5 * * * *` = min 1 through 5 |
| `/` | Step | `*/15 * * * *` = every 15 minutes |

### Examples

```bash
# Edit crontab for current user
crontab -e

# List current crontab
crontab -l

# Remove all cron jobs
crontab -r

# ═══════════════════════════════════════
# SCHEDULE EXAMPLES
# ═══════════════════════════════════════

# Every minute
* * * * * /path/to/script.sh

# Every 5 minutes
*/5 * * * * /path/to/script.sh

# Every hour (at minute 0)
0 * * * * /path/to/script.sh

# Every day at 2:30 AM
30 2 * * * /path/to/backup.sh

# Every Monday at 9:00 AM
0 9 * * 1 /path/to/report.sh

# Every 1st of month at midnight
0 0 1 * * /path/to/monthly_task.sh

# Weekdays at 6 PM
0 18 * * 1-5 /path/to/end_of_day.sh

# Every Sunday at 3 AM (backup)
0 3 * * 0 /usr/bin/tar -czf /backup/home_$(date +\%F).tar.gz /home/

# ═══════════════════════════════════════
# PRACTICAL BACKUP CRON
# ═══════════════════════════════════════
# Nightly backup at 2 AM, log output
0 2 * * * /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1
```

### System-Wide Cron

```bash
# System cron directories (scripts here run automatically):
/etc/cron.hourly/       # Runs every hour
/etc/cron.daily/        # Runs daily
/etc/cron.weekly/       # Runs weekly
/etc/cron.monthly/      # Runs monthly

# System crontab
cat /etc/crontab
```

---

## 18.4 at — One-Time Scheduled Tasks

```bash
# Schedule command for specific time (runs ONCE)
$ at 10:30 PM
at> /path/to/script.sh
at> Ctrl+D                 # End input

# Schedule for tomorrow
echo "/path/to/script.sh" | at tomorrow 9am

# Schedule relative time
echo "reboot" | at now + 5 minutes

# List scheduled at jobs
atq

# Remove scheduled job
atrm 3           # Remove job #3
```

---

## 18.5 Practice & Assessment

### MCQs

**Q1.** `sudo systemctl enable nginx` does:
- A) Starts nginx immediately
- B) Configures nginx to start automatically on boot
- C) Restarts nginx
- D) Shows nginx status

**Answer:** B

---

**Q2.** The cron entry `0 3 * * 0` runs:
- A) Every 3 minutes
- B) At 3 AM every day
- C) At 3 AM every Sunday
- D) Every 3 hours

**Answer:** C (0=Sunday, hour=3, minute=0)

---

**Q3.** `journalctl -u sshd --since "1 hour ago"` shows:
- A) All system logs
- B) SSH logs from the last hour
- C) SSH configuration
- D) Active SSH connections

**Answer:** B

---

### Hands-On

**Task:** Write a cron entry that:
- Runs a backup script `/usr/local/bin/backup.sh`
- Every day at 11:30 PM
- Logs output to `/var/log/backup.log`

```bash
30 23 * * * /usr/local/bin/backup.sh >> /var/log/backup.log 2>&1
```

---

> **Next Topic:** [19 - Bash Scripting Basics](19-bash-scripting-basics.md)
