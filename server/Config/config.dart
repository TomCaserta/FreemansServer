part of FreemansServer;


Map<String, dynamic> GLOBAL_CONFIG = { 
                                        /* DATABASE */
                                        
                                        'db_host': 'localhost',
                                        'db_user': 'root',
                                        'db_password': 'killick1', /* CHANGE THIS */
                                        'db_database': 'freemans',
                                        'db_port': 3307,
                                        
                                        /* WEBSOCKETS */
                                        
                                        'ws_bind_ip': InternetAddress.ANY_IP_V4,
                                        'ws_bind_port': 1337,
                                        
                                        /* QUICKBOOKS INTEGRATION */
                                        'qb_app_ID': 'FFPSoftware',
                                        'qb_app_name': 'Freemans Farm Produce Software'

};