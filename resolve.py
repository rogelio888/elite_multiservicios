import re

path = 'elite_multiservicios_flutter/lib/features/security/presentation/security_shell_screen.dart'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

# For imports, remove server_metrics_view.dart
def resolve_imports(match):
    upstream = match.group(1).strip()
    stashed = match.group(2).strip()
    stashed = stashed.replace("import 'views/server_metrics_view.dart';", "")
    return upstream + '\n' + stashed

content = re.sub(r'<<<<<<< Updated upstream(.*?)\n=======\n(.*?)>>>>>>> Stashed changes', resolve_imports, content, flags=re.DOTALL)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)
print('Resolved security_shell_screen.dart')
