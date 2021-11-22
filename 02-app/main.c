/**
 * @brief		The application entry point.
 * @file
 */

// https://dev.mysql.com/doc/refman/5.6/en/
// https://dev.mysql.com/doc/c-api/5.6/en/

#include <stdlib.h>
#include <stdio.h>
#include <inttypes.h>
#include <assert.h>
#include <mysql.h>

static void
fct0(void)
{
	//---Initialize the library---//
	assert(0	== mysql_library_init(0, NULL, NULL));
	assert(0	== mysql_thread_init());

	//---Initialize---//
	MYSQL	mysql;
	assert(&mysql	== mysql_init(&mysql));

	//---Connect---//
	assert(&mysql	== mysql_real_connect(&mysql, "192.168.1.74", "cedric", "password", NULL, 0, NULL, 0));

	//---Fetch the database names---//
	MYSQL_RES*	myres;
	assert(NULL		!= (myres = mysql_list_dbs(&mysql, NULL)));
	printf("# of rows: %u\n", (uint32_t)mysql_num_rows(myres));
	printf("# of fields: %u\n", mysql_num_fields(myres));
	for (MYSQL_ROW row; NULL != (row = mysql_fetch_row(myres)); ) {
		for (uint32_t field_idx = 0; field_idx < mysql_num_fields(myres); field_idx++) {
			printf("length[%u]: %u ", field_idx, (uint32_t)(mysql_fetch_lengths(myres)[field_idx]));
			MYSQL_FIELD*	myfield;
			assert(NULL	!= (myfield = mysql_fetch_field_direct(myres, field_idx)));
			printf("\"%s\"=\"%s\"", myfield->name, row[0]);
			printf("\n");
		}
		printf("\n");
	}
	mysql_free_result(myres);

	//---Uninitialize---//
	mysql_close(&mysql);

	//---Uninitilaize the library---//
	mysql_thread_end();
	mysql_library_end();
}

/**
 * @brief		The application entry point.
 * @param		[in]	argc	The number of arguments.
 * @param		[in]	argv	The arguments values.
 * @return		Returns EXIT_SUCCESS on success.
 */
extern int
main(int argc, char* argv[])
{
	printf("%s started\n", __func__);
	fct0();
	printf("%s terminated\n", __func__);
	return EXIT_SUCCESS;
}
