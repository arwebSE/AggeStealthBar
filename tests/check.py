"""Run with: uv run --with lupa python tests/check.py (Lua 5.1)."""
from pathlib import Path
from lupa.lua51 import LuaRuntime

root = Path(__file__).resolve().parents[1]
import os
os.chdir(root)
lua = LuaRuntime()
compile_lua = lua.eval('function(code, name) assert(loadstring(code, name)) end')
for path in root.glob('**/*.lua'):
    compile_lua(path.read_text(encoding='utf-8-sig'), str(path))
for cls, conflict in [('ROGUE', False), ('DRUID', False), ('MAGE', False), ('ROGUE', True)]:
    runtime = LuaRuntime()
    runtime.execute(Path('tests/runtime.lua').read_text(), cls, conflict)
    print(f'PASS: {cls}, conflict={conflict}')
toc = Path('AggeStealthBar/AggeStealthBar.toc').read_text()
for line in toc.splitlines():
    if line and not line.startswith('#'):
        assert (root / 'AggeStealthBar' / line.replace('\\', '/')).is_file(), line
assert Path('AggeStealthBar/Media/Icon.tga').is_file()
print('PASS: Lua 5.1 syntax and manifest')
