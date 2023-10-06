#!/usr/bin/env bash
success_if_empty() {
    out=$("$@")
    if [ -z "$out" ]
    then
        echo -e "\033[1;32mNo issues found!\033[0m"
    else
        echo $out
    fi
}

# Always navigate to project root from anywhere
cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../age_unlearning

echo -e "\033[1;36mRunning Testing:\033[0m"
python3 -m coverage run --branch --source . -m pytest -v
echo

echo -e "\033[1;36mRunning Coverage:\033[0m"
python3 -m coverage report --ignore-errors --show-missing |& tee coverage.log
