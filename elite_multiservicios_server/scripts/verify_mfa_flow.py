#!/usr/bin/env python3
"""
Script de Verificación Automatizada del Flujo MFA (8 Pasos)
Elite Multiservicios

Uso:
  python elite_multiservicios_server/scripts/verify_mfa_flow.py [--base-url http://localhost:8080/]
"""

import sys
import os
import json
import urllib.request
import urllib.error
import hashlib
import subprocess
import argparse

def get_env_credentials():
    email = ''
    password = ''
    env_path = os.path.join(os.path.dirname(__file__), '..', '..', '.env')
    if os.path.exists(env_path):
        with open(env_path, 'r', encoding='utf-8') as f:
            for line in f:
                line = line.strip()
                if line.startswith('SEED_ADMIN_EMAIL='):
                    email = line.split('=', 1)[1].strip()
                elif line.startswith('SEED_ADMIN_PASSWORD='):
                    password = line.split('=', 1)[1].strip()
    return email, password

def call_endpoint(base_url, endpoint, method, args, token=None):
    body = {'method': method}
    body.update(args)
    url = f"{base_url.rstrip('/')}/{endpoint}"
    headers = {'Content-Type': 'application/json'}
    if token:
        headers['authorization'] = f"Bearer {token}"
    
    req = urllib.request.Request(
        url,
        data=json.dumps(body).encode('utf-8'),
        headers=headers
    )
    try:
        with urllib.request.urlopen(req) as resp:
            data = resp.read().decode('utf-8')
            return resp.status, json.loads(data) if data else None
    except urllib.error.HTTPError as e:
        raw = e.read().decode('utf-8')
        try:
            parsed = json.loads(raw)
        except Exception:
            parsed = raw
        return e.code, parsed
    except Exception as e:
        return 0, str(e)

def crack_pin_for_hash(target_hash):
    """Fuerza bruta de 6 dígitos (000000 - 999999) en ~100ms."""
    for i in range(1000000):
        code_str = f"{i:06d}"
        if hashlib.sha256(code_str.encode('utf-8')).hexdigest() == target_hash:
            return code_str
    return None

def get_code_from_local_db(challenge_id):
    """Consulta la tabla mfa_challenge en el contenedor Docker local para resolver el código."""
    try:
        sql = f"SELECT \"codeHash\" FROM mfa_challenge WHERE \"challengeId\" = '{challenge_id}' ORDER BY id DESC LIMIT 1;"
        res = subprocess.run(
            ['docker', 'exec', '-i', 'elite_multiservicios_server-postgres-1', 'psql', '-U', 'postgres', '-d', 'elite_multiservicios', '-t', '-A', '-c', sql],
            capture_output=True,
            text=True,
            check=True
        )
        code_hash = res.stdout.strip()
        if code_hash:
            return crack_pin_for_hash(code_hash)
    except Exception as e:
        print(f"[Aviso] No se pudo leer hash de BD Docker local: {e}")
    return None

def main():
    parser = argparse.ArgumentParser(description='Verificación integral del flujo MFA')
    parser.add_argument('--base-url', default='http://localhost:8080/', help='URL base del backend')
    parser.add_argument('--email', default='', help='Email del usuario')
    parser.add_argument('--password', default='', help='Contraseña del usuario')
    parser.add_argument('--code', default='', help='Código MFA manual (si no se usa DB local)')
    args = parser.parse_args()

    env_email, env_password = get_env_credentials()
    email = args.email or env_email
    password = args.password or env_password
    base_url = args.base_url

    print("=" * 70)
    print(f"VERIFICACIÓN DE FLUJO MFA EN: {base_url}")
    print(f"Usuario objetivo: {email}")
    print("=" * 70)

    # -------------------------------------------------------------
    # PASO 1: Login con emailIdp.login
    # -------------------------------------------------------------
    print("\n[PASO 1/8] Ejecutando login (emailIdp.login)...")
    status, res = call_endpoint(base_url, 'emailIdp', 'login', {'email': email, 'password': password})
    if status != 200 or not res or 'token' not in res:
        print(f"[FAIL] Fallo login: Status {status}, Resp: {res}")
        sys.exit(1)
    token = res['token']
    auth_user_id = res.get('authUserId')
    print(f"  [OK] Login exitoso. Token obtenido (authUserId: {auth_user_id})")

    # -------------------------------------------------------------
    # PASO 2: Registrar sesion con sessionManagement.registerSession
    # -------------------------------------------------------------
    print("\n[PASO 2/8] Registrando sesion (sessionManagement.registerSession, mfaVerified: false)...")
    status, res = call_endpoint(base_url, 'sessionManagement', 'registerSession', {'mfaVerified': False}, token=token)
    if status != 200:
        print(f"[FAIL] Fallo registerSession: Status {status}, Resp: {res}")
        sys.exit(1)
    session_id = res
    print(f"  [OK] Sesion registrada exitosamente (UserSession id: {session_id})")

    # -------------------------------------------------------------
    # PASO 3: Verificar que isSessionVerified devuelve false
    # -------------------------------------------------------------
    print("\n[PASO 3/8] Comprobando estado inicial (mfa.isSessionVerified)...")
    status, res = call_endpoint(base_url, 'mfa', 'isSessionVerified', {}, token=token)
    if status != 200 or res is not False:
        print(f"[FAIL] Error: Se esperaba isSessionVerified == False, se obtuvo: {res} (Status {status})")
        sys.exit(1)
    print("  [OK] isSessionVerified retorno False (sesion correctamente no verificada)")

    # -------------------------------------------------------------
    # PASO 4: Obtener challenge con mfa.checkRequired
    # -------------------------------------------------------------
    print("\n[PASO 4/8] Solicitando challenge MFA (mfa.checkRequired)...")
    status, res = call_endpoint(base_url, 'mfa', 'checkRequired', {'rememberMe': False, 'trustedDeviceToken': None}, token=token)
    if status != 200 or not res or 'challengeId' not in res:
        print(f"[FAIL] Fallo checkRequired: Status {status}, Resp: {res}")
        sys.exit(1)
    challenge_id = res['challengeId']
    print(f"  [OK] Challenge emitido: {challenge_id}")

    # -------------------------------------------------------------
    # PASO 5: Verificar codigo MFA con mfa.verifyMfa
    # -------------------------------------------------------------
    print("\n[PASO 5/8] Verificando codigo MFA (mfa.verifyMfa)...")
    mfa_code = args.code
    if not mfa_code:
        mfa_code = get_code_from_local_db(challenge_id)
    
    if not mfa_code:
        print("  [AVISO] Ingrese manualmente el codigo MFA recibido:")
        mfa_code = input("  Codigo (6 digitos): ").strip()

    status, res = call_endpoint(base_url, 'mfa', 'verifyMfa', {
        'challengeId': challenge_id,
        'code': mfa_code,
        'rememberMe': False
    }, token=token)

    if status != 200 or not res or not res.get('success'):
        print(f"[FAIL] Fallo verifyMfa: Status {status}, Resp: {res}")
        sys.exit(1)
    print(f"  [OK] verifyMfa respondio exitosamente ({res})")

    # -------------------------------------------------------------
    # PASO 6: Verificar que isSessionVerified devuelve true
    # -------------------------------------------------------------
    print("\n[PASO 6/8] Comprobando que la sesion ahora este verificada (mfa.isSessionVerified)...")
    status, res = call_endpoint(base_url, 'mfa', 'isSessionVerified', {}, token=token)
    if status != 200 or res is not True:
        print(f"[FAIL] Error: Se esperaba isSessionVerified == True, se obtuvo: {res} (Status {status})")
        sys.exit(1)
    print("  [OK] isSessionVerified retorno True con authSessionId sincronizado")

    # -------------------------------------------------------------
    # PASO 7 & 8: Llamar a endpoint protegido y verificar 200 OK
    # -------------------------------------------------------------
    print("\n[PASO 7/8] Invocando endpoint de negocio protegido (crmAgenda.listTasks)...")
    status, res = call_endpoint(base_url, 'crmAgenda', 'listTasks', {'limit': 20, 'offset': 0}, token=token)

    print(f"\n[PASO 8/8] Evaluando codigo de estado HTTP recibido...")
    if status == 200:
        tasks_count = len(res) if isinstance(res, list) else 'N/A'
        print(f"  [OK] EXITO TOTAL: crmAgenda.listTasks devolvio HTTP 200 OK (Tareas retornadas: {tasks_count})")
        print("\n" + "=" * 70)
        print("TODOS LOS 8 PASOS DE VERIFICACION COMPLETADOS SATISFACTORIAMENTE")
        print("=" * 70)
        return 0
    elif status == 500:
        print(f"[FAIL] ERROR CRITICO 500: El endpoint fallo con Internal Server Error. Resp: {res}")
        sys.exit(1)
    else:
        print(f"[FAIL] Fallo: Se esperaba 200, se obtuvo HTTP {status}. Resp: {res}")
        sys.exit(1)

if __name__ == '__main__':
    sys.exit(main() or 0)
