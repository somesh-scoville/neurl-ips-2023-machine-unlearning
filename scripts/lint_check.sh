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

cd "$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/..  # Always navigate to project root from anywhere

echo -e "\033[1;36mRunning Pylint:\033[0m"
python3 -m pylint age_unlearning

echo -e "\033[1;36mRunning MyPy:\033[0m"
python3 -m mypy age_unlearning
echo

echo -e "\033[1;36mRunning flake518:\033[0m"
success_if_empty python3 -m flake518 age_unlearning
