#include <cstdio>
#include "../../Include/MDDRealtimeSynchronize.h"

#include "gtest/gtest.h"

namespace {

TEST(ProcPrio, normal) {
    void* procPrio = MDD_ProcessPriorityConstructor();
    MDD_setPriority(procPrio, 0);
    MDD_ProcessPriorityDestructor(procPrio);
}

TEST(MDD_RTSync, defaults) {

    double availableTime, computingTime, wallClockTime;
    double Ts = 0.1;
    double scaling = 1;
    int alwaysInTime = 1;
    void* procPrio = MDD_ProcessPriorityConstructor();
    double simStartTime = 0;
    double simTime = simStartTime;
    double lastSimTime = simStartTime;
    int shouldCatchupTime = 0;
    void* rtSync = MDD_RTSyncConstructor(simStartTime, shouldCatchupTime);

    printf("Priority \"Normal\" with Ts=%f, scaling=%f, simStartTime=%f\n", Ts, scaling, simStartTime);
    MDD_setPriority(procPrio, 0);

    for (simTime = simStartTime; simTime < 1.0; simTime += Ts) {
        MDD_RTSyncSynchronize(rtSync, simTime, scaling, &wallClockTime, &availableTime, &computingTime, &lastSimTime);
        printf("simTime: %f, availableTime: %f, scaling: %4.2f, wallClockTime: %f, computingTime: %f, lastSimTime: %f\n", simTime, availableTime, scaling, wallClockTime, computingTime, lastSimTime);
        alwaysInTime = alwaysInTime && availableTime >= 0;
    }
    printf("Priority \"Normal\", alwaysInTime: %s\n", alwaysInTime ? "true" : "false");
    MDD_RTSyncDestructor(rtSync);
    MDD_ProcessPriorityDestructor(procPrio);
    EXPECT_GT(alwaysInTime, 0);
}


TEST(MDD_RTSync, scaling2) {

    double availableTime, computingTime, wallClockTime;
    double Ts = 0.1;
    double scaling = 2;
    int alwaysInTime = 1;
    void* procPrio = MDD_ProcessPriorityConstructor();
    double simStartTime = 0;
    double simTime = simStartTime;
    double lastSimTime = simStartTime;
    int shouldCatchupTime = 0;
    void* rtSync = MDD_RTSyncConstructor(simStartTime, shouldCatchupTime);

    printf("Priority \"Normal\" with Ts=%f, scaling=%f, simStartTime=%f\n", Ts, scaling, simStartTime);
    MDD_setPriority(procPrio, 0);
    
    for (simTime = simStartTime; simTime < 1.0; simTime += Ts) {
        MDD_RTSyncSynchronize(rtSync, simTime, scaling, &wallClockTime, &availableTime, &computingTime, &lastSimTime);
        printf("simTime: %f, availableTime: %f, scaling: %4.2f, wallClockTime: %f, computingTime: %f, lastSimTime: %f\n", simTime, availableTime, scaling, wallClockTime, computingTime, lastSimTime);
        alwaysInTime = alwaysInTime && availableTime >= 0;
    }
    printf("Priority \"Normal\", alwaysInTime: %s\n", alwaysInTime ? "true" : "false");
    MDD_RTSyncDestructor(rtSync);
    MDD_ProcessPriorityDestructor(procPrio);
    EXPECT_GT(alwaysInTime, 0);
}

TEST(MDD_RTSync, startTime02) {

    double availableTime, computingTime, wallClockTime;
    double Ts = 0.1;
    double scaling = 1;
    int alwaysInTime = 1;
    void* procPrio = MDD_ProcessPriorityConstructor();
    double simStartTime = 0.2;
    double simTime = simStartTime;
    double lastSimTime = simStartTime;
    int shouldCatchupTime = 0;
    void* rtSync = MDD_RTSyncConstructor(simStartTime, shouldCatchupTime);

    printf("Priority \"Normal\" with Ts=%f, scaling=%f, simStartTime=%f\n", Ts, scaling, simStartTime);
    MDD_setPriority(procPrio, 0);

    for (simTime = simStartTime; simTime < 1.0; simTime += Ts) {
        MDD_RTSyncSynchronize(rtSync, simTime, scaling, &wallClockTime, &availableTime, &computingTime, &lastSimTime);
        printf("simTime: %f, availableTime: %f, scaling: %4.2f, wallClockTime: %f, computingTime: %f, lastSimTime: %f\n", simTime, availableTime, scaling, wallClockTime, computingTime, lastSimTime);
        alwaysInTime = alwaysInTime && availableTime >= 0;
    }
    printf("Priority \"Normal\", alwaysInTime: %s\n", alwaysInTime ? "true" : "false");
    MDD_RTSyncDestructor(rtSync);
    MDD_ProcessPriorityDestructor(procPrio);
    EXPECT_GT(alwaysInTime, 0);
}

}
