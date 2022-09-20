def get_volume_pools():
    """ Get a list of pools where to search for Resalloc-related volumes """
    return ["images"]


def get_hv_identification_from_pool_id(pool_id):
    """ Get unique ID of the hypervisor """
    if pool_id.startswith("copr_hv_x86_64_01"):
        return (
            0,
            "qemu+ssh://copr@vmhost-x86-copr01"
            ".rdu-cc.fedoraproject.org/system",
            "x86_64",
        )
    if pool_id.startswith("copr_hv_x86_64_02"):
        return (
            1,
            "qemu+ssh://copr@vmhost-x86-copr02"
            ".rdu-cc.fedoraproject.org/system",
            "x86_64",
        )
    if pool_id.startswith("copr_hv_x86_64_03"):
        return (
            2,
            "qemu+ssh://copr@vmhost-x86-copr03"
            ".rdu-cc.fedoraproject.org/system",
            "x86_64",
        )
    if pool_id.startswith("copr_hv_x86_64_04"):
        return (
            3,
            "qemu+ssh://copr@vmhost-x86-copr04"
            ".rdu-cc.fedoraproject.org/system",
            "x86_64",
        )
    if pool_id.startswith("copr_hv_ppc64le_01"):
        return (
            4,
            "qemu+ssh://copr@vmhost-p08-copr01"
            ".rdu-cc.fedoraproject.org/system",
            "ppc64le",
        )
    if pool_id.startswith("copr_hv_ppc64le_02"):
        return (
            5,
            "qemu+ssh://copr@vmhost-p08-copr02"
            ".rdu-cc.fedoraproject.org/system",
            "ppc64le",
        )

    if pool_id.startswith("copr_p09_01"):
        return (
            6,
            "qemu+ssh://copr@vmhost-p09-copr01"
            ".rdu-cc.fedoraproject.org/system",
            "ppc64le",
        )
    raise Exception("can't convert pool_id to hv ID")
