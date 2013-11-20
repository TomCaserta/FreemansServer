part of FreemansServer;


Map<String, dynamic> GLOBAL_SETTINGS = { 
                                        /* DATABASE */
                                        
                                        'db_host': 'localhost',
                                        'db_user': 'root',
                                        'db_password': 'killick1',
                                        'db_database': 'freemans',
                                        'db_port': 3307,
                                        
                                        /* WEBSOCKETS */
                                        
                                        'ws_bind_ip': InternetAddress.ANY_IP_V4,
                                        'ws_bind_port': 1337,
                                        'ws_bind_type': "SERVER",

                                         'ws_bind_options': "ws://http://www.freemansfamrproduce.com/connection/server.dart?run=positive"
                                        
};