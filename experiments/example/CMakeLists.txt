###
### Target: higher-order-experiment
###

add_executable(higher-order-experiment higher-order-experiment.cpp)

target_link_libraries(higher-order-experiment sos-opt ${libs})

if(WITH_GUROBI)
    target_link_libraries(higher-order-experiment "${GUROBI_LIBRARY}")
endif()
