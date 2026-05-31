import os

env_paths = [
    os.path.expanduser('~/aviaj.com/.env'),
    os.path.expanduser('~/lp.ajath.ae/.env')
]

updates = {
    'MAIL_MAILER': 'smtp',
    'MAIL_SCHEME': 'smtps',
    'MAIL_HOST': 'ajath.ae',
    'MAIL_PORT': '465',
    'MAIL_USERNAME': 'info@ajath.ae',
    'MAIL_PASSWORD': '"Ajath@#007!$&"',
    'MAIL_FROM_ADDRESS': 'info@ajath.ae',
    'MAIL_FROM_NAME': '"Ajath UAE"'
}

for path in env_paths:
    if not os.path.exists(path):
        print(f"Skipping {path} (does not exist)")
        continue
        
    with open(path, 'r') as f:
        lines = f.readlines()
        
    new_lines = []
    seen = set()
    for line in lines:
        line_strip = line.strip()
        if '=' in line_strip and not line_strip.startswith('#'):
            parts = line_strip.split('=', 1)
            k = parts[0].strip()
            if k in updates:
                new_lines.append(f"{k}={updates[k]}\n")
                seen.add(k)
                continue
        new_lines.append(line)
        
    for k, v in updates.items():
        if k not in seen:
            new_lines.append(f"{k}={v}\n")
            
    with open(path, 'w') as f:
        f.writelines(new_lines)
    print(f"Successfully updated {path}")
