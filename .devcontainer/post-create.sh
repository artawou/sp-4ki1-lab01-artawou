#!/usr/bin/env bash
# ЗГЕНЕРОВАНО з content/sp/environment/lab01.yml — E11-9, ADR 022.
#
# Цей скрипт навмисно ЗАВЖДИ завершується кодом 0. Його запускає postCreateCommand, а
# postCreateCommand, що впав, ламає створення Codespace — студент бачить лише «щось пішло
# не так» і не має де працювати. Тому кожен крок тут доповідає про себе, але не валить
# простір; справжня перевірка — .devcontainer/verify.sh, і її запускає людина.
set -u

# Утиліти з `tools` — у РОБОЧОМУ просторі. Усередині навчальних контейнерів студент
# ставить їх сам: це частина роботи, а не зручність.
if ! sudo apt-get update \
  || ! sudo apt-get install -y --no-install-recommends curl git iproute2 procps python3 util-linux; then
  printf '%s\n' 'не вдалося поставити частину утиліт — перевір bash .devcontainer/verify.sh' >&2
fi
sudo rm -rf /var/lib/apt/lists/*

# Підказка про квоту — у власному терміналі студента, бо жодного важеля з нашого боку
# немає: простір тарифікується його особистому акаунту, і політики організації на нього
# не поширюються. Друкується при кожному відкритті оболонки, дописується один раз.
grep -qF 'printf '\''%s\n%s\n'\'' '\''Здав роботу? Видали цей простір: https://github.com/codespaces'\'' '\''Сховище витрачає твою квоту, доки простір існує, — навіть зупинений.'\'' # vtfk:quota' "$HOME"/.bashrc 2>/dev/null || printf '%s\n' 'printf '\''%s\n%s\n'\'' '\''Здав роботу? Видали цей простір: https://github.com/codespaces'\'' '\''Сховище витрачає твою квоту, доки простір існує, — навіть зупинений.'\'' # vtfk:quota' >> "$HOME"/.bashrc

# Пасхалка середовища. Не критична: якщо не вдалася — простір усе одно робочий.
if printf '%s\n' 'Диспетчер бачить усе, просто не патякає. // 0xC1D' | sudo tee '/etc/motd' >/dev/null; then
  grep -qF '[ -f '\''/etc/motd'\'' ] && cat '\''/etc/motd'\'' # vtfk:egg' "$HOME"/.bashrc 2>/dev/null || printf '%s\n' '[ -f '\''/etc/motd'\'' ] && cat '\''/etc/motd'\'' # vtfk:egg' >> "$HOME"/.bashrc
fi

printf '\n%s\n' 'Простір готовий. Перевір середовище: bash .devcontainer/verify.sh'
exit 0
