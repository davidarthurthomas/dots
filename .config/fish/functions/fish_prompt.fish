function fish_prompt
    echo -n "$USER@"(hostname -s)" "(prompt_pwd)" > "
end
