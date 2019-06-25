const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.createTask = functions.firestore
                        .document('projects/{projectId}/tasks/{taskId}')
                        .onCreate(async (snap, context) => {
                            const projectRef = snap.ref.parent.parent;
                            const projectSnap = await projectRef.get();
                            const projectData = projectSnap.data();

                            return projectRef.update({
                                noOfTasks: projectData.noOfTasks + 1
                            });
                        });

exports.deleteTask = functions.firestore
                        .document('projects/{projectId}/tasks/{taskId}')
                        .onDelete(async (snap, context) => {
                            const data = snap.data();
                            const projectRef = snap.ref.parent.parent;
                            const projectSnap = await projectRef.get();
                            const projectData = projectSnap.data();

                            if (data['completed']) {
                                return projectRef.update({
                                    noOfTasks: projectData.noOfTasks - 1,
                                    noOfTasksCompleted: projectData.noOfTasksCompleted - 1
                                });
                            }

                            return projectRef.update({
                                noOfTasks: projectData.noOfTasks - 1
                            });
                        });

exports.updateTask = functions.firestore
                        .document('projects/{projectId}/tasks/{taskId}')
                        .onUpdate(async (change, context) => {
                            const beforeData = change.before.data();
                            const afterData = change.after.data();

                            if(beforeData['completed'] !== afterData['completed']) {
                                const projectRef = change.after.ref.parent.parent;
                                const projectSnap = await projectRef.get();
                                const projectData = projectSnap.data();
                                if (afterData['completed'] === true) {
                                    return projectRef.update({
                                        noOfTasksCompleted: projectData.noOfTasksCompleted + 1
                                    });
                                }
                                return projectRef.update({
                                    noOfTasksCompleted: projectData.noOfTasksCompleted - 1
                                });
                            }
                            return false;
                        });