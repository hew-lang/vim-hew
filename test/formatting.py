"""Execute the README's formatting recipes against an installed Hew compiler."""
import os
from pathlib import Path
import re
import subprocess
import tempfile

root = Path(__file__).resolve().parents[1]
compiler = Path(os.environ['HEW_COMPILER']).resolve()
editor = os.environ.get('HEW_TEST_EDITOR', 'vim')
readme = (root / 'README.md').read_text()
recipe = re.search(r'```vim\n(function! HewFormat\(\).*?)\n```', readme, re.S).group(1)
manual = re.search(r'```vim\n(:%!hew fmt.*?)\n```', readme, re.S).group(1)

with tempfile.TemporaryDirectory(prefix='vim-hew-format-') as directory:
    temporary = Path(directory)
    (temporary / 'bin').mkdir()
    (temporary / 'bin/hew').symlink_to(compiler)
    env = dict(os.environ, PATH=str(temporary / 'bin') + os.pathsep + os.environ['PATH'],
               HEW_HOME=str(temporary / 'hew-home'))
    source = temporary / 'source with spaces.hew'
    saved = 'fn main() {\n    println("saved");\n}\n'
    edited = 'fn main(){println("unsaved");}'
    cases = {
        'manual unsaved buffer': [
            manual,
            "call assert_equal(['fn main() {', '    println(\"unsaved\");', '}'], getline(1, '$'))",
            "call assert_equal(['fn main() {', '    println(\"saved\");', '}'], readfile(expand('%:p')))",
        ],
        'format on save': [
            recipe, 'write',
            "call assert_equal(['fn main() {', '    println(\"unsaved\");', '}'], getline(1, '$'))",
            "call assert_equal(getline(1, '$'), readfile(expand('%:p')))",
        ],
        'failed format on save': [
            recipe,
            "call setline(1, 'fn main( {')",
            "let before = getline(1, '$')",
            "let failed = 0", 'try', '  write', 'catch /hew fmt failed:/',
            '  let failed = 1', 'endtry',
            "call assert_equal(1, failed, 'formatter failure must stop the write')",
            "call assert_equal(before, getline(1, '$'), 'failure must preserve buffer')",
            "call assert_equal(['fn main() {', '    println(\"saved\");', '}'], readfile(expand('%:p')), 'failure must preserve disk')",
        ],
    }
    for name, commands in cases.items():
        source.write_text(saved)
        script = temporary / 'test.vim'
        script.write_text('\n'.join([
            'set nomore', 'edit ' + str(source).replace(' ', '\\ '),
            "call setline(1, '" + edited + "')", "2,$delete _",
            *commands,
            'if len(v:errors)',
            "  call writefile(v:errors, '" + str(temporary / 'errors') + "')",
            '  cquit', 'endif', 'q!',
        ]) + '\n')
        args = [editor, '-u', 'NONE', '-i', 'NONE', '-n']
        args += ['--headless'] if Path(editor).name == 'nvim' else ['-es']
        p = subprocess.run([*args, '-S', str(script)], env=env, capture_output=True, text=True, timeout=30)
        if p.returncode:
            errors = temporary / 'errors'
            detail = errors.read_text() if errors.exists() else p.stdout + p.stderr
            raise SystemExit(f'{name} failed: {detail}')
        print(f'PASS: {name}')
