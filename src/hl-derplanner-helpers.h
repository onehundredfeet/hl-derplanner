#ifndef __HL_DERPLANNER_HELPERS_H_
#define __HL_DERPLANNER_HELPERS_H_

#pragma once
#include <derplanner/runtime/domain.h>

inline plnnr::Database_Format *domain_info_get_format( plnnr::Domain_Info *info) {
    return &info->database_req;
}

#endif