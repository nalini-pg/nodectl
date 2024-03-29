import util, db
import os, sys, time

thisDir = os.path.dirname(os.path.realpath(__file__))
ctl = "./pgedge "

pgN = os.getenv("pgN", "")
if pgN == "":
    pgN = util.DEFAULT_PG
pgV = "pg" + str(pgN)

pause = int(os.getenv("pgePause", "4"))

withPOSTGREST = str(os.getenv("withPOSTGREST", "False"))
withCAT = str(os.getenv("withCAT", "False"))
withBACKREST = str(os.getenv("withBACKREST", "False"))

isAutoStart = str(os.getenv("isAutoStart", "False"))
isDebug = str(os.getenv("pgeDebug", "0"))


def error_exit(p_msg, p_rc=1):
    util.message("ERROR: " + p_msg)
    if isDebug == "0":
        os.system(ctl + "remove pgedge")

    sys.exit(p_rc)


def osSys(cmd, fatal_exit=True):
    isSilent = os.getenv("isSilent", "False")
    if isSilent == "False":
        s_cmd = util.scrub_passwd(cmd)
        util.message("#")
        util.message("# " + str(s_cmd))

    rc = os.system(cmd)
    if rc != 0 and fatal_exit:
        error_exit("FATAL ERROR running install-pgedge", 1)

    return


def check_pre_reqs():
    global prt

    util.message("#### Checking for Pre-Req's #########################")
    platf = util.get_platform()

    util.message("  Verify Linux")
    if platf != "Linux":
        error_exit("OS must be Linux")

    if platf == "Linux":
        util.message("  Verify Linux supported glibc version")
        if util.get_glibc_version() < "2.28":
            error_exit("Linux has unsupported (older) version of glibc")

        if isAutoStart == "True":
            util.message("  Verify SELinux is not active")
            if util.is_selinux_active():
               error_exit("SELinux must not be active for --autostart mode")
    

    util.message("  Verify Python 3.9+")
    p3_minor_ver = util.get_python_minor_version()
    if p3_minor_ver < 9:
        error_exit("Python version must be greater than 3.9")

    util.message("  Verify non-root user")
    if util.is_admin():
        error_exit("You must install as non-root user with passwordless sudo privleges")

    if os.getenv("pgePort", "") == "":
        util.message(f"  Verify default port {prt} availability")
        while util.is_socket_busy(prt):
            prt = prt + 1
            util.message(f"  Verify default port {prt} availability")
    else:
        util.message(f"  Verify specific port {prt} availability")
        if util.is_socket_busy(prt):
           error_exit(f"Port {prt} is unavailable")

    util.message(f"  Using port {prt}")

    data_dir = "data/" + pgV
    util.message("  Verify empty data directory '" + data_dir + "'")
    if os.path.exists(data_dir):
        dir = os.listdir(data_dir)
        if len(dir) != 0:
            error_exit("The '" + data_dir + "' directory is not empty")

    if usr:
        util.message("  Verify -U usr & -P passwd...")
        usr_l = usr.lower()
        if usr_l == "pgedge":
            error_exit("The user defined supersuser may not be called 'pgedge'")

        if usr_l == util.get_user():
            error_exit("The user-defined superuser may not be the same as the OS user")

        usr_len = len(usr_l)
        if (usr_len < 1) or (usr_len > 64):
            error_exit("The user-defined superuser must be >=1 and <= 64 in length")

        if passwd:
            pwd_len = len(passwd)
            if (pwd_len < 6) or (pwd_len > 128):
                error_exit("The password must be >= 6 and <= 128 in length")

            for pwd_char in passwd:
                pwd_c = pwd_char.strip()
                if pwd_c in (",", "'", '"', "@", ""):
                    error_exit(
                        "The password must not contain {',', \"'\", \", @, or a space"
                    )

        else:
            error_exit("Must specify a -P passwd when specifying a -U usr")


# MAINLINE #####################################################3

util.message("'./pgedge install pgedge' is deprecated!!   Use './pgedge setup' instead.", "warning")

svcuser = util.get_user()

db1 = os.getenv("pgName", "")
if db1 == "":
    db1 = "postgres"

usr = os.getenv("pgeUser", None)
passwd = os.getenv("pgePasswd", None)
prt = 0
try:
    prt = int(os.getenv("pgePort", "5432"))
except Exception:
    error_exit("Port " + os.getenv("pgePort") + " is not an integer")

check_pre_reqs()

osSys(ctl + "install " + pgV)

if util.is_empty_writable_dir("/data") == 0:
    util.message("## symlink empty local data directory to empty /data ###")
    osSys("rm -rf data; ln -s /data data")

if isAutoStart == "True":
    util.message("\n## init & config autostart  ###############")
    osSys(ctl + "init " + pgV + " --svcuser=" + svcuser)
    osSys(ctl + "config " + pgV + " --autostart=on")
else:
    osSys(ctl + "init " + pgV)

osSys(ctl + "config " + pgV + " --port=" + str(prt))

osSys(ctl + "start " + pgV)
time.sleep(pause)

db.create(db1, usr, passwd, pgN)

time.sleep(pause)

if withPOSTGREST == "True":
    util.message("  ")
    osSys(ctl + "install postgrest")

if withBACKREST == "True":
    util.message("  ")
    osSys(ctl + "install backrest")

if withCAT == "True":
    util.message("  ")
    osSys(ctl + "install pgcat")
