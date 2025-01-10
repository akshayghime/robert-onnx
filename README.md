# robert-onnx
Deployment of RoBERTa- SequenceClassification ONNX model by packaging it within a container which serves flask app to perform predictions

Following the steps:
1. Create requirements.txt file with dependencies:
    simpletransformers==0.4.0
    tensorboardX==1.9
    transformers==2.1.0
    Flask>=2.2.2
    torch==1.11.0
    onnxruntime==1.12.0
    numpy<2

2. Create makefile with given instructions:
    install:
        pip install --upgrade pip &&\
            pip install -r requirements.txt

    lint:
        pylint --disable=R,C app.py

    format:
        black *.py

    test:
        python -m pytest -vv --cov=app app.py
    (When you run a makefile, makesure you have requirements.txt file in the same directory)

3. Create Dockerfile that installs everything in the container:
    FROM python:3.8
    COPY ./requirements.txt /webapp/requirements.txt
    WORKDIR /webapp
    RUN pip install -r requirements.txt
    COPY webapp/* /webapp
    ENTRYPOINT [ "python" ]
    CMD [ "app.py" ]
    (The Dockerfile copies the requirements file, creates a webapp directory, and copies
    the application code into a single app.py file.)

4. Create the webapp/app.py file to perform the sentiment analysis. Start by adding the imports and everything required to create an ONNX runtime session.

5. The predict() function is a Flask route that enables the /predict URL when the appli‐
cation is running. The function only allows POST HTTP methods.

6. Download the RoBERTa- https://github.com/onnx/models/blob/bec48b6a70e5e9042c0badbaafefe4454e072d08/validated/text/machine_comprehension/roberta/model/roberta-sequence-classification-9.onnx SequenceClassification ONNX model locally, and place it at the root of the project.

7. This is how the final project structure should look:
.
├── Dockerfile
├── makefile
├── README.md
├── requirements.txt
├── roberta-sequence-classification-9.onnx
└── webapp
    └── app.py

8. One last thing missing before building the container is that there is no instruction to
    copy the model into the container. The app.py file requires the model roberta-
    sequence-classification-9.onnx to exist in the /webapp directory. Update the Dockerfile
    to reflect that:
    COPY roberta-sequence-classification-9.onnx /webapp

9. The ONNX model exists at the root of the project, but the application wants it in
the /webapp directory, so move it inside that directory so that the Flask app doesn’t
complain (this extra step is not needed when the container runs):
$ mv roberta-sequence-classification-9.onnx webapp/