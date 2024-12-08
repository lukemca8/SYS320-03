ip addr | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '^127'
