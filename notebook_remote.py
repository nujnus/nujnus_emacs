from flask import Flask
app = Flask(__name__)


import queue
from jupyter_client import manager

#写法参考了ipython_slack客户端:
#https://github.com/pravj/ipython_slack_client

class KernelClient():
    """Wrapper implementation of jupyter_client.
    Initial reference: https://git.io/fN2T2 (gist by @abalter)
    """

    def __init__(self):
        self.kernel_manager, self.kernel_client = manager.start_new_kernel()


    def execute(self, code_string):
        req_msg_id = self.kernel_client.execute(code_string)
        execute_reply = self.kernel_client.get_shell_msg(req_msg_id)

        io_message_content = self.kernel_client.get_iopub_msg(timeout=0)['content']
        if io_message_content.get('execution_state', None) == 'idle':
            return None

        while True:
            message_content = io_message_content

            try:
                io_message_content = self.kernel_client.get_iopub_msg(timeout=0)['content']
                if io_message_content.get('execution_state', None) == 'idle':
                    break
            except queue.Empty:
                break

        result_type = ''
        if 'data' in message_content:
            result = message_content['data']['text/plain']
            result_type = 'data'
        elif message_content.get('name', '') == 'stdout':
            result = message_content['text']
            result_type = 'stdout'
        elif 'traceback' in message_content:
            result = '\n'.join(message_content['traceback'])
            result_type = 'error'
        else:
            result = ''

        return result_type, result

kc = KernelClient() #创建一个kernel



import base64
from flask import request
@app.route('/interpret', methods=['POST','GET'])
def interpret():
    error = None
    if request.method == 'POST':
        code = request.form['code']
        if(len(code)%3 == 1): 
            code += "=="
        elif(len(code)%3 == 2): 
            code += "=" 
        print(code)

        code = base64.b64decode(code).decode('UTF-8')
        print(code)
        result = kc.execute(code)
        return(result[0]+":\n"+result[1])


if __name__ == '__main__':
    #app.run(debug=True)
    #app.run(host='0.0.0.0',port=80)
    app.run(port=8000)
    #app.run(debug=True, port=8000)
    #app.run()
